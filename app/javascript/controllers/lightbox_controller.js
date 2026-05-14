import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "image", "item", "title"]

  connect() {
    this.currentIndex = 0
    this.handleKeydown = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
  }

  open(event) {
    const button = event.currentTarget

    this.show(Number(button.dataset.lightboxIndex))
    document.addEventListener("keydown", this.handleKeydown)
    this.dialogTarget.showModal()
  }

  previous() {
    this.show(this.currentIndex - 1)
  }

  next() {
    this.show(this.currentIndex + 1)
  }

  show(index) {
    if (this.itemTargets.length === 0) return

    this.currentIndex = (index + this.itemTargets.length) % this.itemTargets.length
    const button = this.itemTargets[this.currentIndex]

    this.imageTarget.src = button.dataset.lightboxSrc
    this.imageTarget.alt = button.dataset.lightboxAlt
    this.titleTarget.textContent = button.dataset.lightboxTitle
  }

  close() {
    document.removeEventListener("keydown", this.handleKeydown)
    this.dialogTarget.close()
    this.imageTarget.removeAttribute("src")
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  handleKeydown(event) {
    if (!this.dialogTarget.open) return

    if (event.key === "ArrowLeft") this.previous()
    if (event.key === "ArrowRight") this.next()
  }
}
