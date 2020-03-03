import invoke
import dotfiles.tasks


def run():
    ns = dotfiles.tasks.get_ns()
    program = invoke.Program(namespace=ns)
    program.run()
