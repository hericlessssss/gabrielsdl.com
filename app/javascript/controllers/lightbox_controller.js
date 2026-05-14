import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "image", "title"]

  open(event) {
    const button = event.currentTarget

    this.imageTarget.src = button.dataset.lightboxSrc
    this.imageTarget.alt = button.dataset.lightboxAlt
    this.titleTarget.textContent = button.dataset.lightboxTitle
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
    this.imageTarget.removeAttribute("src")
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }
}
