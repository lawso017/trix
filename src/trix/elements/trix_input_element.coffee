{makeElement} = Trix

TextAreaElement = Trix.createElementClass(window.HTMLTextAreaElement)

Trix.defineElement class extends TextAreaElement
  @tagName: "trix-input"
  @extends: "textarea"

  @defaultCSS: """
    %t {
      resize: none;
    }
  """

  uncloneableAttributeNames = ["is", "id", "name"]
  cloneStyles = maxHeight: "0px", position: "absolute", left: "-9999px"

  attachedCallback: ->
    super
    @clone = makeElement(@tagName)

    for name, value of getAttributes(this)
      unless name in uncloneableAttributeNames
        @clone.setAttribute(name, value)

    for key, value of cloneStyles
      @clone.style[key] = value

    @parentNode.insertBefore(@clone, this)
    @addEventListener("input", @autoResize)
    @autoResize()

  detachedCallback: ->
    super
    @clone.parentNode.removeChild(@clone)

  autoResize: =>
    @clone.value = @value
    @style.height = @clone.scrollHeight + "px"

  getAttributes = (element) ->
    attributes = {}
    for key, attribute of element.attributes
      if attribute.name and typeof attribute.value is "string"
        attributes[attribute.name] = attribute.value
    attributes