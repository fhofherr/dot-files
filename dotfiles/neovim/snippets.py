import jinja2

_closers_tmpl = jinja2.Template("""
# File auto-generated; DO NOT EDIT

global !p
from snippets import *
endglobal
{% for c in closers %}
{%- if c.context %}
context "{{ c.context }}"
{% else %}
{#- add white space #}
{% endif -%}
snippet {{ c.trigger }} "{{ c.description }}" {{ c.opts }}
{{ c.lhs }}${1}{{ c.rhs }}{% if c.sfx %}{{ c.sfx }}{% endif %}${0}
endsnippet
{% endfor %}
""".strip())

_closer_data = [{
    "trigger": "'",
    "lhs": "'",
    "rhs": "'",
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, '\\'')",
}, {
    "trigger": "`",
    "lhs": "\\`",
    "rhs": "\\`",
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, '`')",
}, {
    "trigger": '"',
    "lhs": '"',
    "rhs": '"',
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, '\"')",
}, {
    "trigger":
    "(",
    "lhs":
    "(",
    "rhs":
    ")",
    "opts":
    "ie",
    "description":
    "",
    "context":
    "not (cursor_after(snip, '((') or cursor_before(snip, ')'))"
}, {
    "trigger":
    "[",
    "lhs":
    "[",
    "rhs":
    "]",
    "opts":
    "ie",
    "description":
    "",
    "context":
    "not (cursor_after(snip, '[[') or cursor_before(snip, ']'))"
}, {
    "trigger":
    "{",
    "lhs":
    "\\{",
    "rhs":
    "\\}",
    "opts":
    "i",
    "description":
    "",
    "context":
    "not (cursor_after(snip, '{{') or cursor_before(snip, '}'))"
}, {
    "trigger": "((",
    "lhs": "(\n\t",
    "rhs": "\n)",
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, ')')"
}, {
    "trigger": "[[",
    "lhs": "[\n\t",
    "rhs": "\n]",
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, ']')"
}, {
    "trigger": "{{",
    "lhs": "\\{\n\t",
    "rhs": "\n\\}",
    "opts": "ie",
    "description": "",
    "context": "not cursor_before(snip, '}')"
}, {
    "trigger": "(,",
    "lhs": "(\n\t",
    "rhs": "\n)",
    "sfx": ",",
    "opts": "i",
    "description": ""
}, {
    "trigger": "[,",
    "lhs": "[\n\t",
    "rhs": "\n]",
    "sfx": ",",
    "opts": "i",
    "description": ""
}, {
    "trigger": "{,",
    "lhs": "\\{\n\t",
    "rhs": "\n\\}",
    "sfx": ",",
    "opts": "i",
    "description": ""
}, {
    "trigger": "(;",
    "lhs": "(\n\t",
    "rhs": "\n)",
    "sfx": ";",
    "opts": "i",
    "description": ""
}, {
    "trigger": "[;",
    "lhs": "[\n\t",
    "rhs": "\n]",
    "sfx": ";",
    "opts": "i",
    "description": ""
}, {
    "trigger": "{;",
    "lhs": "\\{\n\t",
    "rhs": "\n\\}",
    "sfx": ";",
    "opts": "i",
    "description": ""
}]


def render_closers():
    return _closers_tmpl.render(closers=_closer_data)
