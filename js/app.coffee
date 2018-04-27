React = require 'preact'
Redux = require 'redux'
fetch$ = require 'kefir-fetch'
helpers = require './helpers'
templates = require './templates'

reducer = (state={}, action) ->
    switch action.type
        when 'set'
            return Object.assign state, action.set
    return state # Fallback

initial_state =
    query: helpers.randomChoice templates
    loading: false
    result: null

Store = Redux.createStore reducer, initial_state

Dispatcher =
    set: (set) ->
        Store.dispatch
            type: 'set'
            set: set

class App extends React.Component
    constructor: ->
        @state = Store.getState()

    componentDidMount: ->
        Store.subscribe =>
            @setState Store.getState()

    onInput: (e) ->
        query = e.target.value
        Dispatcher.set {query}

    submit: ->
        {query} = @state
        Dispatcher.set {loading: true, result: null}
        fetch$ 'post', 'https://api.json.party/graphql.json', {body: {query}}
            .onValue (result) ->
                Dispatcher.set {loading: false, result}

    render: ->
        <div>
            <textarea value=@state.query onInput=@onInput />
            {if @state.loading
                <button disabled=true>Partying...</button>
            else
                <button onClick=@submit.bind(@)>Party!</button>
            }
            {if @state.result
                <pre>{JSON.stringify @state.result, null, 4}</pre>
            }
        </div>

$app = document.getElementById 'app'
$app.innerHTML = ''
React.render <App />, $app
