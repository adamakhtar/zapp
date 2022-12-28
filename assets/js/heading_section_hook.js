
export default {
  mounted() {
    this.textarea = this.getTextarea()
    this.el.addEventListener("heading_section:reveal_form", this.revealForm.bind(this))
    this.el.addEventListener("heading_section:hide_form", this.hideForm.bind(this))
    this.textarea.addEventListener("keyup", this.autofit.bind(this))
    this.textarea.addEventListener("keydown", this.save.bind(this))
  },

  // destroyed() {

  // },

  revealForm(_event) {
    this.getForm().style.display = 'block'
    this.getHeading().style.display = 'none'
    this.focus()
    this.autofit()
  },

  hideForm(_event) {
    this.getForm().style.display = 'none'
    this.getHeading().style.display = 'block'
  },


  getHeading() {
    return this.el.querySelector('.js-output');
  },

  getHeadingText(){
    return this.el.querySelector('.js-heading');
  },

  getTextarea(){
    return this.el.querySelector('textarea');
  },

  getForm(){
    return this.el.querySelector('.js-form')
  },

  save(event){
    if (event.keyCode == 13) {
      // pressed enter so set the heading to the contents of the form and then
      // reveal it and bubble up a submit event so the liveview/live component
      // can react accordingly with a phx-submit
      event.preventDefault();
      this.getHeadingText().textContent = this.getTextarea().value
      this.getForm().style.display = 'none'
      this.getHeading().style.display = 'block'
      this.getForm().dispatchEvent(
        new Event("submit", {bubbles: true, cancelable: true})
      );
    }
  },

  autofit() {
    const input = this.getTextarea()
    input.style.height = 'auto';
    input.style.height = input.scrollHeight + 'px';
  },

  focus() {
    const textarea = this.getTextarea()
    textarea.focus()
    // ensure caret is placed at end
    textarea.setSelectionRange(textarea.value.length, textarea.value.length)
  }
};