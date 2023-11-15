from django import template
import urllib.parse

register = template.Library()


@register.filter
def urldecode(value):
    return urllib.parse.unquote(value)
