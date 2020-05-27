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
{{ c.lhs }}${1}{{ c.rhs }}${0}
endsnippet
{% endfor %}
""".strip())

_closer_data = [{
    "trigger": ",)",
    "lhs": "(\n\t",
    "rhs": "\n),",
    "opts": "i",
    "description": ""
}, {
    "trigger": ",]",
    "lhs": "[\n\t",
    "rhs": "\n],",
    "opts": "i",
    "description": ""
}, {
    "trigger": ",}",
    "lhs": "\\{\n\t",
    "rhs": "\n\\},",
    "opts": "i",
    "description": ""
}, {
    "trigger": ";)",
    "lhs": "(\n\t",
    "rhs": "\n);",
    "opts": "i",
    "description": ""
}, {
    "trigger": ";]",
    "lhs": "[\n\t",
    "rhs": "\n];",
    "opts": "i",
    "description": ""
}, {
    "trigger": ";}",
    "lhs": "\\{\n\t",
    "rhs": "\n\\};",
    "opts": "i",
    "description": ""
}]


def render_closers():
    return _closers_tmpl.render(closers=_closer_data)
