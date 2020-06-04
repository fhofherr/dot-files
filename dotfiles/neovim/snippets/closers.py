import jinja2

_closers_tmpl = jinja2.Template("""
# File auto-generated; DO NOT EDIT

{% for c in closers %}
snippet {{ c.trigger }} "{{ c.description }}" {{ c.opts }}
{{ c.lhs }}${1}{{ c.rhs }}${0}
endsnippet
{% endfor %}
""".strip())

_closer_data = [{
    "trigger": "((",
    "lhs": "(\n\t",
    "rhs": "\n)",
    "opts": "i",
    "description": ""
}, {
    "trigger": "[[",
    "lhs": "[\n\t",
    "rhs": "\n]",
    "opts": "i",
    "description": ""
}, {
    "trigger": "{{",
    "lhs": "{\n\t",
    "rhs": "\n}",
    "opts": "i",
    "description": ""
}, {
    "trigger": "(,",
    "lhs": "(\n\t",
    "rhs": "\n),",
    "opts": "i",
    "description": ""
}, {
    "trigger": "[,",
    "lhs": "[\n\t",
    "rhs": "\n],",
    "opts": "i",
    "description": ""
}, {
    "trigger": "{,",
    "lhs": "\\{\n\t",
    "rhs": "\n\\},",
    "opts": "i",
    "description": ""
}, {
    "trigger": "(;",
    "lhs": "(\n\t",
    "rhs": "\n);",
    "opts": "i",
    "description": ""
}, {
    "trigger": "[;",
    "lhs": "[\n\t",
    "rhs": "\n];",
    "opts": "i",
    "description": ""
}, {
    "trigger": "{;",
    "lhs": "\\{\n\t",
    "rhs": "\n\\};",
    "opts": "i",
    "description": ""
}]


def render():
    return _closers_tmpl.render(closers=_closer_data)
