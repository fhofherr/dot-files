_same_line_closer_tmpl = """
snippet {trigger} "{description}" {opts}
{lhs}${{1}}{rhs}${{0}}
endsnippet
""".strip()

_multi_line_closer_tmpl = """
snippet {trigger} "{description}" {opts}
{lhs}
\t${{1}}
{rhs}${{0}}
endsnippet
""".strip()

_multi_line_sfx_closer_tmpl = """
snippet {trigger} "{description}" {opts}
{lhs}
\t${{1}}
{rhs}{sfx}${{0}}
endsnippet
""".strip()


def same_line_closers():
    data = [{
        "trigger": "'",
        "lhs": "'",
        "rhs": "'",
        "opts": "",
        "description": ""
    }, {
        "trigger": "`",
        "lhs": "\\`",
        "rhs": "\\`",
        "opts": "",
        "description": ""
    }, {
        "trigger": '"',
        "lhs": '"',
        "rhs": '"',
        "opts": "",
        "description": ""
    }, {
        "trigger": "(",
        "lhs": "(",
        "rhs": ")",
        "opts": "i",
        "description": ""
    }, {
        "trigger": "[",
        "lhs": "[",
        "rhs": "]",
        "opts": "i",
        "description": ""
    }, {
        "trigger": "{",
        "lhs": "\\{",
        "rhs": "\\}",
        "opts": "i",
        "description": ""
    }]
    return [_same_line_closer_tmpl.format(**d) for d in data]


def multi_line_closers():
    data = [{
        "trigger": '"""',
        "lhs": '"""',
        "rhs": '"""',
        "opts": "",
        "description": ""
    }, {
        "trigger": "'''",
        "lhs": "'''",
        "rhs": "'''",
        "opts": "",
        "description": ""
    }, {
        "trigger": "(>",
        "lhs": "(",
        "rhs": ")",
        "opts": "",
        "description": ""
    }, {
        "trigger": "[>",
        "lhs": "[",
        "rhs": "]",
        "opts": "",
        "description": ""
    }, {
        "trigger": "{>",
        "lhs": "\\{",
        "rhs": "\\}",
        "opts": "s",
        "description": ""
    }]
    return [_multi_line_closer_tmpl.format(**d) for d in data]


def multi_line_sfx_closers():
    data = [{
        "trigger": "(,",
        "lhs": "(",
        "rhs": ")",
        "sfx": ",",
        "opts": "",
        "description": ""
    }, {
        "trigger": "[,",
        "lhs": "[",
        "rhs": "]",
        "sfx": ",",
        "opts": "",
        "description": ""
    }, {
        "trigger": "{,",
        "lhs": "\\{",
        "rhs": "\\}",
        "sfx": ",",
        "opts": "",
        "description": ""
    }, {
        "trigger": "(;",
        "lhs": "(",
        "rhs": ")",
        "sfx": ";",
        "opts": "",
        "description": ""
    }, {
        "trigger": "[;",
        "lhs": "[",
        "rhs": "]",
        "sfx": ";",
        "opts": "",
        "description": ""
    }, {
        "trigger": "{;",
        "lhs": "\\{",
        "rhs": "\\}",
        "sfx": ";",
        "opts": "",
        "description": ""
    }]
    return [_multi_line_sfx_closer_tmpl.format(**d) for d in data]
