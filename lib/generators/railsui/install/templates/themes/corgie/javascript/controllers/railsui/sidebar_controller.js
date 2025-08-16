import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.storageKey = "railsui-sidebar-collapsed";
    this.initializeFromStorage();
    this.setupMediaQuery();
    this.setupKeyboardShortcuts();
  }

  initializeFromStorage() {
    const storedState = localStorage.getItem(this.storageKey);
    this.isCollapsed = storedState === "true";

    this.isCollapsed ? this.applyCollapsedState() : this.applyExpandedState();
  }

  setupMediaQuery() {
    this.mediaQuery = window.matchMedia("(max-width: 1024px)");
    this.handleMediaQuery(this.mediaQuery);
    this.mediaQuery.addEventListener("change", this.handleMediaQuery);
  }

  handleMediaQuery = (mq) => {
    if (mq.matches) {
      this.collapse(false);
    } else {
      this.isCollapsed ? this.collapse(false) : this.expand(false);
    }
  };

  toggle = () => {
    this.isCollapsed ? this.expand() : this.collapse();
  };

  collapse(saveToStorage = true) {
    this.isCollapsed = true;
    this.applyCollapsedState();
    if (saveToStorage) {
      localStorage.setItem(this.storageKey, "true");
    }
  }

  expand(saveToStorage = true) {
    this.isCollapsed = false;
    this.applyExpandedState();
    if (saveToStorage) {
      localStorage.setItem(this.storageKey, "false");
    }
  }

  applyCollapsedState() {
    this.containerTarget.classList.remove("sidebar-expanded", "w-64");
    this.containerTarget.classList.add("sidebar-collapsed", "w-16");
  }

  applyExpandedState() {
    this.containerTarget.classList.remove("sidebar-collapsed", "w-16");
    this.containerTarget.classList.add("sidebar-expanded", "w-64");
  }

  setupKeyboardShortcuts() {
    document.addEventListener("keydown", this.handleKeyboardShortcut);
  }

  handleKeyboardShortcut = (event) => {
    const { shiftKey, metaKey, ctrlKey, key } = event;
    const isModifierPressed = metaKey || ctrlKey;

    if (shiftKey && isModifierPressed && key === "O") {
      event.preventDefault();
      this.newChat();
    }

    if (isModifierPressed && key === "k") {
      event.preventDefault();
      this.openSearch();
    }

    if (isModifierPressed && key === "b") {
      event.preventDefault();
      this.toggle();
    }
  };

  openSearch() {
    const searchElement = document.querySelector('[data-controller*="search"]');
    if (!searchElement) return;

    const searchController =
      this.application.getControllerForElementAndIdentifier(
        searchElement,
        "search",
      );

    searchController?.open?.();
  }

  disconnect() {
    this.mediaQuery?.removeEventListener("change", this.handleMediaQuery);
    document.removeEventListener("keydown", this.handleKeyboardShortcut);
  }
}
