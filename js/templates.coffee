module.exports = [
    '''{user{name}}'''
    '''{user{name, email, pets{name, type}}}'''
    '''{pets{name, type}}'''
    '''{users{name, friends{name, email}}}'''
]
