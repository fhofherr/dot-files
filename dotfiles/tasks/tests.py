from invoke import task

TOX = "tox --asdf-no-fallback --asdf-install"


@task()
def test_py36(c):
    c.run(f"{TOX} -e py36", pty=True)


@task()
def test_py37(c):
    c.run(f"{TOX} -e py37", pty=True)


@task()
def test_py38(c):
    c.run(f"{TOX} -e py38", pty=True)
