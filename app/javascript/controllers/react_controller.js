import { Controller } from "@hotwired/stimulus"
import React from "react"
import { createRoot } from "react-dom/client"
import PasswordValidator from "../components/PasswordValidator"

// Connects to data-controller="react"
export default class extends Controller {
  connect() {
    console.log("React controller connected!")
    createRoot(this.element).render(<PasswordValidator />)
  }
}
