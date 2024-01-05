import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-form"
export default class extends Controller {
  static targets = ['form'];

  connect() {
    console.log('search form controller connected');
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 1000);
  }
}
