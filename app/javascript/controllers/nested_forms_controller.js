import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  addAssociation(event) {
    event.preventDefault()
    // Replace NEW_RECORD with a unique timestamp so the nested form fields don't collide
    const time = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, time)

    // Insert the new set of fields into the container
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeAssociation(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")

    // If it's a brand new (unsaved) record, just remove the entire field
    if (wrapper.dataset.newRecord == "true") {
      wrapper.remove()
    } else {
      // If it's an existing record, set the _destroy value to "1" and hide the fields
      wrapper.querySelector("input[name*='_destroy']").value = "1"
      wrapper.style.display = "none"
    }
  }
}

