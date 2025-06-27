import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.tagIndex = this.containerTarget.querySelectorAll(".tag-entry").length
  }

  addTag(event) {
    event.preventDefault()

    const newTagHTML = `
      <div class="tag-entry">
        <label>Tag Name</label>
        <input type="text" name="blog[blog_tags_attributes][${this.tagIndex}][tag_attributes][name]" />

        <label>Rank</label>
        <input type="number" name="blog[blog_tags_attributes][${this.tagIndex}][rank]" />

        <a href="#" data-action="click->blog-form#removeTag">Remove</a>
      </div>
    `
    this.containerTarget.insertAdjacentHTML("beforeend", newTagHTML)
    this.tagIndex++
  }

  removeTag(event) {
    event.preventDefault()
    event.target.closest(".tag-entry").remove()
  }

  get containerTarget() {
    return this.targets.find("container")
  }
}
