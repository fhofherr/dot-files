import os
import shutil
import datetime

import dotfiles.fs as fs


class TestConfigFile(object):
    def test_create_symlink(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        fs.safe_link_file(tmpfile, dest)
        assert os.path.samefile(tmpfile, dest)

    def test_create_intermediate_directories(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'intermediate', 'dest')
        fs.safe_link_file(tmpfile, dest)
        assert os.path.samefile(tmpfile, dest)

    def test_skip_existing_links_to_same_file(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        os.symlink(tmpfile, dest)
        fs.safe_link_file(tmpfile, dest)

    def test_replace_identical_file_by_symlink(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        with open(tmpfile, 'w') as f:
            f.write('some content')
        shutil.copy(tmpfile, dest)
        fs.safe_link_file(tmpfile, dest)
        assert os.path.samefile(tmpfile, dest)
        assert os.path.islink(dest)

    def test_create_backup_of_existing_file(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        with open(tmpfile, 'w') as f:
            f.write('some content')
        with open(dest, 'w') as f:
            f.write('totally different content')
        bkpfile = fs._backup_file_name(dest)
        fs.safe_link_file(tmpfile, dest)
        assert os.path.exists(bkpfile)
        with open(bkpfile, 'r') as f:
            txt = f.read()
            assert 'totally different content' == txt

    def test_delete_symlink(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        fs.safe_link_file(tmpfile, dest)
        fs.safe_remove_link(tmpfile, dest)
        assert not os.path.exists(dest)

    def test_dont_delete_unknown_files(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        with open(dest, 'w') as f:
            f.write('some poor innocent file')
        fs.safe_link_file(tmpfile, dest)
        fs.safe_remove_link(tmpfile, dest)
        assert os.path.exists(dest)
        with open(dest, 'r') as f:
            txt = f.read()
            assert 'some poor innocent file' == txt

    def test_restore_previous_backup(self, tmpdir, tmpfile):
        dest = os.path.join(tmpdir, 'dest')
        with open(dest, 'w') as f:
            f.write('some unrelated file')
        bkpfile = fs._backup_file_name(dest)
        fs.safe_link_file(tmpfile, dest)
        fs.safe_remove_link(tmpfile, dest)
        assert not os.path.exists(bkpfile)
        assert os.path.exists(dest)
        with open(dest, 'r') as f:
            txt = f.read()
            assert 'some unrelated file' == txt

    def test_delete_empty_intermediate_directories(self, tmpdir, tmpfile):
        intermediate_dir = os.path.join(tmpdir, 'intermediate')
        dest = os.path.join(intermediate_dir, 'dest')
        fs.safe_link_file(tmpfile, dest)
        fs.safe_remove_link(tmpfile, dest)
        assert not os.path.exists(intermediate_dir)

    def test_leave_non_empty_intermediate_directories_alone(
        self, tmpdir, tmpfile):
        intermediate_dir = os.path.join(tmpdir, 'intermediate')
        os.makedirs(intermediate_dir)
        dest = os.path.join(intermediate_dir, 'dest')
        some_file = os.path.join(intermediate_dir, 'some_file')
        with open(some_file, 'w') as f:
            f.write('something')
        fs.safe_link_file(tmpfile, dest)
        fs.safe_remove_link(tmpfile, dest)
        assert os.path.exists(some_file)


class TestBackup(object):
    def test_create_backup_copy(self, tmpfile):
        bkpdate = datetime.datetime.now().strftime('%Y%m%d')
        bkpfile = '{}.{}.1'.format(tmpfile, bkpdate)
        actual = fs._backup(tmpfile)
        assert os.path.exists(bkpfile)
        assert fs._files_identical(tmpfile, bkpfile)
        assert bkpfile == actual

    def test_increment_version_number(self, tmpfile):
        bkpdate = datetime.datetime.now().strftime('%Y%m%d')
        bkpfile = '{}.{}.2'.format(tmpfile, bkpdate)
        # Create and ignore a first backup
        fs._backup(tmpfile)
        actual = fs._backup(tmpfile)
        assert os.path.exists(bkpfile)
        assert fs._files_identical(tmpfile, bkpfile)
        assert bkpfile == actual

    def test_no_backups_exist(self, tmpfile):
        assert fs._find_latest_backup(tmpfile) is None

    def test_just_one_backup_exists(self, tmpfile):
        bkpfile = fs._backup(tmpfile)
        actual = fs._find_latest_backup(tmpfile)
        assert bkpfile == actual

    def test_many_backups_exist(self, tmpfile):
        # We need more than 10 files to test for correct sorting.
        bkpfile = ''
        for i in range(11):
            bkpfile = fs._backup(tmpfile)
        assert bkpfile == fs._find_latest_backup(tmpfile)
