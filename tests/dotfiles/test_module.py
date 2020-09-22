import os
import random

import pytest

from dotfiles import module


class TestRun:
    class MockModuleA(module.Definition):
        name = "mock_module_a"

        @module.install
        def install(self):
            self.install_called = True

        @module.update
        def update(self):
            self.update_called = True

        @module.uninstall
        def uninstall(self):
            self.uninstall_called = True

    @pytest.mark.parametrize(
        "cmd",
        [
            "install",
            "update",
            # "uninstall"
        ])
    def test_run_single_module(self, mocker, mock_argv, cmd):
        mods_dir = "./fake/modules/dir"
        home_dir = "./fake/home/dir"
        state_dir = "./fake/state/dir"

        mock_argv(f"--modules-dir={mods_dir}", f"--home-dir={home_dir}",
                  f"--state-dir={state_dir}", cmd)

        mod_inst = TestRun.MockModuleA._new_instance(mods_dir, home_dir,
                                                     state_dir, {})
        mock_loader = mocker.Mock(module.Loader, autospec=True)
        mock_loader.load.return_value = ([mod_inst], {mod_inst.name: mod_inst})
        mock_save_state = mocker.patch("dotfiles.state.save_state")

        module.run(TestRun.MockModuleA,
                   mods_dir=mods_dir,
                   home_dir=home_dir,
                   loader=mock_loader)

        mock_loader.load.assert_called_once()
        mock_save_state.assert_called_once_with(state_dir, mod_inst.state)

        assert getattr(mod_inst, f"{cmd}_called")


class TestLoader:
    @pytest.fixture
    def no_modules_loader(self, tmpdir):
        return module.Loader(
            mod_dir=tmpdir,
            home_dir=os.path.join(tmpdir, "home"),
            state_dir=os.path.join(tmpdir, "state"),
        )

    @pytest.fixture
    def modules_loader(self, tmpdir, modules_dir):
        return module.Loader(
            modules_dir,
            home_dir=os.path.join(tmpdir, "home"),
            state_dir=os.path.join(tmpdir, "state"),
        )

    def test_no_modules_found(self, no_modules_loader):
        mods, mods_by_name = no_modules_loader.load()
        assert not mods
        assert not mods_by_name

    def test_modules_found(self, modules_loader):
        expected_modules = {
            "asdf",
            "bat",
            "git",
            "golang",
        }
        mods, mods_by_name = modules_loader.load()
        mod_names = set(mods_by_name.keys())
        assert set(m.name for m in mods) == mod_names
        # We may add more modules in the future and don't want this test
        # to fail for each new module.
        assert expected_modules <= mod_names

    def test_filter_modules_by_predicates(self, modules_loader):
        mods, mods_by_name = modules_loader.load(filter_by=[
            lambda m: m.mod_def.name.startswith("g"),
            lambda m: m.mod_def.name.endswith("t"),
            lambda m: len(m.mod_def.name) == 3,
        ])
        assert {"git"} == set(m.name for m in mods)
        assert mods_by_name["git"] == mods[0]

    def test_reduce_modules(self, modules_loader):
        mods, mods_by_name = modules_loader.load(reduce_by=[
            lambda ms: [m for m in ms if m.mod_def.name in {"git", "asdf"}]
        ])
        assert {"git", "asdf"} == set(m.name for m in mods)
        assert mods_by_name["git"] in mods
        assert mods_by_name["asdf"] in mods

    def test_inject_required_dependencies(self, modules_loader):
        mods = modules_loader.load()
        for mod in mods:
            if not hasattr(mod, "required"):
                continue
            for req_name in mod.required:
                assert hasattr(mod, req_name)
                req = getattr(mod, req_name)
                assert isinstance(req, module._Protector)
                assert req._mod in mods

    def test_inject_optional_dependencies(self, modules_loader):
        mods = modules_loader.load()
        for mod in mods:
            if not hasattr(mod, "optional"):
                continue
            for req_name in mod.optional:
                assert hasattr(mod, req_name)
                req = getattr(mod, req_name)
                assert isinstance(req, module._Protector)
                assert req._mod in mods

    def test_inject_None_for_missing_optional_deps(self, modules_loader):
        mods, mods_by_name = modules_loader.load(
            filter_by=[module.has_any_tag(["essential"])])
        for mod in mods:
            if not hasattr(mod, "optional"):
                continue
            for req_name in mod.optional:
                assert hasattr(mod, req_name)
                req = getattr(mod, req_name)
                assert (req_name in mods_by_name and req) or (req is None)


class TestReduceByModDef:
    class MockModuleA(module.Definition):
        name = "mock_module_a"

    class MockModuleB(module.Definition):
        name = "mock_module_b"
        required = ["mock_module_a"]

    class MockModuleC(module.Definition):
        name = "mock_module_c"
        required = ["mock_module_a"]
        optional = ["mock_module_b"]

    @pytest.fixture
    def all_mod_infos(self, tmpdir):
        return [
            module.Loader.ModInfo(
                os.path.join(tmpdir, TestReduceByModDef.MockModuleA.name),
                TestReduceByModDef.MockModuleA),
            module.Loader.ModInfo(
                os.path.join(tmpdir, TestReduceByModDef.MockModuleB.name),
                TestReduceByModDef.MockModuleB),
            module.Loader.ModInfo(
                os.path.join(tmpdir, TestReduceByModDef.MockModuleC.name),
                TestReduceByModDef.MockModuleC),
        ]

    @pytest.fixture
    def required_mod_infos(self, tmpdir):
        return [
            module.Loader.ModInfo(
                os.path.join(tmpdir, TestReduceByModDef.MockModuleA.name),
                TestReduceByModDef.MockModuleA),
            module.Loader.ModInfo(
                os.path.join(tmpdir, TestReduceByModDef.MockModuleC.name),
                TestReduceByModDef.MockModuleC),
        ]

    @pytest.mark.parametrize("mod_name,expected_modules", [
        ("mock_module_a", {"mock_module_a"}),
        ("mock_module_b", {"mock_module_b", "mock_module_a"}),
        ("mock_module_c", {"mock_module_c", "mock_module_b", "mock_module_a"}),
    ])
    def test_reduce_modules_by_name(self, mod_name, expected_modules,
                                    all_mod_infos):
        mods = module.reduce_by_mod(mod_name)(all_mod_infos)
        mod_names = set(m.mod_def.name for m in mods)
        assert expected_modules == mod_names

    @pytest.mark.parametrize("mod_def_name,expected_modules", [
        ("MockModuleA", {"mock_module_a"}),
        ("MockModuleB", {"mock_module_b", "mock_module_a"}),
        ("MockModuleC", {"mock_module_c", "mock_module_b", "mock_module_a"}),
    ])
    def test_reduce_modules_by_def(self, mod_def_name, expected_modules,
                                   all_mod_infos):
        mod_def = getattr(TestReduceByModDef, mod_def_name)
        mods = module.reduce_by_mod(mod_def)(all_mod_infos)
        mod_names = set(m.mod_def.name for m in mods)
        assert expected_modules == mod_names

    @pytest.mark.parametrize("mod_name,expected_modules", [
        ("mock_module_a", {"mock_module_a"}),
        ("mock_module_c", {"mock_module_c", "mock_module_a"}),
    ])
    def test_skip_optional_dependencies(self, mod_name, expected_modules,
                                        required_mod_infos):
        mods = module.reduce_by_mod(mod_name)(required_mod_infos)
        mod_names = set(m.mod_def.name for m in mods)
        assert expected_modules == mod_names


class TestFilterModulesByTags:
    class MockModuleA(module.Definition):
        name = "mock_module_a"
        tags = ["common-tag", "tag-a"]

    class MockModuleB(module.Definition):
        name = "mock_module_b"
        tags = ["common-tag", "tag-b"]

    class MockModuleC(module.Definition):
        name = "mock_module_c"
        tags = ["common-tag", "tag-c"]

    @pytest.fixture
    def mod_infos(self, tmpdir):
        return [
            module.Loader.ModInfo(tmpdir, TestFilterModulesByTags.MockModuleA),
            module.Loader.ModInfo(tmpdir, TestFilterModulesByTags.MockModuleB),
            module.Loader.ModInfo(tmpdir, TestFilterModulesByTags.MockModuleC),
        ]

    def test_no_tags_passed(self, mod_infos):
        for mi in mod_infos:
            assert module.has_any_tag([])(mi)

    def test_tags_match_all_modules(self, mod_infos):
        tag = "common-tag"
        for mi in mod_infos:
            if tag in mi.mod_def.tags:
                assert module.has_any_tag(["common-tag"])(mi)
            else:
                assert not module.has_any_tag(["common-tag"])(mi)


class TestSortByDependencies:
    class MockModuleA(module.Definition):
        name = "mock_module_a"
        required = ["mock_module_c", "mock_module_b"]
        optional = ["mock_module_d"]

    class MockModuleB(module.Definition):
        name = "mock_module_b"
        required = ["mock_module_c"]
        optional = ["mock_module_d"]

    class MockModuleC(module.Definition):
        name = "mock_module_c"
        optional = ["mock_module_d"]

    class MockModuleD(module.Definition):
        name = "mock_module_d"

    class MockModuleY(module.Definition):
        name = "mock_module_y"
        required = ["mock_module_z"]

    class MockModuleZ(module.Definition):
        name = "mock_module_z"
        required = ["mock_module_y"]

    @pytest.fixture
    def all_mod_infos(self, tmpdir):
        modules = [
            TestSortByDependencies.MockModuleA,
            TestSortByDependencies.MockModuleB,
            TestSortByDependencies.MockModuleC,
            TestSortByDependencies.MockModuleD,
        ]
        random.shuffle(modules)
        return [module.Loader.ModInfo(tmpdir, m) for m in modules]

    @pytest.fixture
    def required_mod_infos(self, tmpdir):
        modules = [
            TestSortByDependencies.MockModuleA,
            TestSortByDependencies.MockModuleB,
            TestSortByDependencies.MockModuleC,
        ]
        random.shuffle(modules)
        return [module.Loader.ModInfo(tmpdir, m) for m in modules]

    @pytest.fixture
    def cyclic_mod_infos(self, tmpdir):
        return [
            module.Loader.ModInfo(tmpdir, TestSortByDependencies.MockModuleY),
            module.Loader.ModInfo(tmpdir, TestSortByDependencies.MockModuleZ),
        ]

    def test_sort_all_dependencies(self, all_mod_infos):
        sorted_mod_infos = module.sort_by_dependencies(all_mod_infos)
        self._assert_modules_in_order(sorted_mod_infos)
        assert len(sorted_mod_infos) == len(all_mod_infos)

    def test_sort_required_dependencies(self, required_mod_infos):
        sorted_mod_infos = module.sort_by_dependencies(required_mod_infos)
        self._assert_modules_in_order(sorted_mod_infos)
        assert len(sorted_mod_infos) == len(required_mod_infos)

    def _assert_modules_in_order(self, sorted_mod_infos):
        for i, mod_info in enumerate(sorted_mod_infos):
            previous_modules = set(info.mod_def.name
                                   for info in sorted_mod_infos[0:i])

            if not previous_modules:
                # The first item in sorted_modules must never have any
                # dependencies.
                assert not mod_info.mod_def.required

            for dep in mod_info.mod_def.required:
                assert dep in previous_modules

    def test_sort_cyclic_dependencies(self, cyclic_mod_infos):
        with pytest.raises(module.DependencyError):
            module.sort_by_dependencies(cyclic_mod_infos)


class TestDefinition:
    class NoDeps(module.Definition):
        name = "no_deps"

    class OneDep(module.Definition):
        name = "one_dep"
        required = ["no_deps"]

    class ManyDeps(module.Definition):
        name = "many_deps"
        required = ["no_deps", "one_dep"]

    def test_new_instance(self, tmpdir):
        home_dir = f"{tmpdir}/home_dir"
        state_dir = f"{tmpdir}/state_dir"

        no_deps = TestDefinition.NoDeps._new_instance(tmpdir, home_dir,
                                                      state_dir, {})
        assert isinstance(no_deps, TestDefinition.NoDeps)
        assert no_deps.mod_dir == tmpdir
        assert no_deps.home_dir == home_dir
        assert no_deps.state
        assert no_deps.log

        one_dep = TestDefinition.OneDep._new_instance(
            tmpdir, home_dir, state_dir, {TestDefinition.NoDeps.name: no_deps})
        assert isinstance(one_dep, TestDefinition.OneDep)
        assert one_dep.mod_dir == tmpdir
        assert one_dep.home_dir == home_dir
        assert one_dep.no_deps._mod == no_deps
        assert one_dep.state
        assert one_dep.log

        many_deps = TestDefinition.ManyDeps._new_instance(
            tmpdir,
            home_dir,
            state_dir,
            {
                TestDefinition.NoDeps.name: no_deps,
                TestDefinition.OneDep.name: one_dep
            },
        )
        assert isinstance(many_deps, TestDefinition.ManyDeps)
        assert many_deps.mod_dir == tmpdir
        assert many_deps.home_dir == home_dir
        assert many_deps.no_deps._mod == no_deps
        assert many_deps.one_dep._mod == one_dep
        assert many_deps.state
        assert many_deps.log


class TestExportDecorator:
    class MockModule(module.Definition):
        name = "mock_module"

        @property
        def some_property(self):
            return "some_property"

        @module.export
        def exported_method(self):
            return "exported method called"

        def unexported_method(self):
            return "you'll never get this"

    class CallableMockModule(module.Definition):
        name = "callable_mock_module"

        @module.export
        def __call__(self):
            return "module called"

    class UnexportedCallableMockModule(module.Definition):
        name = "unexported_callable_mock_module"

        def __call__(self):
            return "you'll never get this"

    @pytest.fixture
    def mock_module(self, tmpdir):
        mod = TestExportDecorator.MockModule._new_instance(
            tmpdir, tmpdir, tmpdir, {})
        return module._Protector(mod)

    @pytest.fixture
    def callable_mock_module(self, tmpdir):
        mod = TestExportDecorator.CallableMockModule._new_instance(
            tmpdir, tmpdir, tmpdir, {})
        return module._Protector(mod)

    @pytest.fixture
    def unexported_callable_mock_module(self, tmpdir):
        mod = TestExportDecorator.UnexportedCallableMockModule._new_instance(
            tmpdir, tmpdir, tmpdir, {})
        return module._Protector(mod)

    def test_access_fields(self, mock_module):
        assert mock_module.name == "mock_module"
        assert mock_module.required == []
        assert mock_module.tags == []

    def test_access_properties(self, mock_module):
        assert mock_module.some_property == "some_property"

    def test_cannot_access_unknown_attribute(self, mock_module):
        with pytest.raises(AttributeError):
            mock_module.unknown_attribute

    def test_access_exported_method(self, mock_module):
        assert "exported method called" == mock_module.exported_method()

    def test_cannot_call_non_callable_module(self, mock_module):
        with pytest.raises(TypeError):
            mock_module()

    def test_cannot_access_unexported_method(self, mock_module):
        with pytest.raises(AttributeError):
            mock_module.unexported_method()

    def test_call_callable_magic_module(self, callable_mock_module):
        assert "module called" == callable_mock_module()

    def test_cannot_call_unexported__call__method(
            self, unexported_callable_mock_module):
        with pytest.raises(AttributeError):
            unexported_callable_mock_module.unexported_method()
