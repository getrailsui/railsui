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

    // Apply the stored state
    if (this.isCollapsed) {
      this.applyCollapsedState();
    } else {
      this.applyExpandedState();
    }
  }

  setupMediaQuery() {
    this.mediaQuery = window.matchMedia("(max-width: 1024px)");
    this.handleMediaQuery(this.mediaQuery);
    this.mediaQuery.addListener(this.handleMediaQuery.bind(this));
  }

  handleMediaQuery(mq) {
    if (mq.matches) {
      this.collapse(false); // Don't save to localStorage for responsive behavior
    } else {
      // On larger screens, restore the user's preference
      if (this.isCollapsed) {
        this.collapse(false);
      } else {
        this.expand(false);
      }
    }
  }

  toggle() {
    if (this.isCollapsed) {
      this.expand();
    } else {
      this.collapse();
    }
  }

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
    document.addEventListener(
      "keydown",
      this.handleKeyboardShortcut.bind(this),
    );
  }

  handleKeyboardShortcut(event) {
    if (
      event.shiftKey &&
      (event.metaKey || event.ctrlKey) &&
      event.key === "O"
    ) {
      event.preventDefault();
      this.newChat();
    }
    if ((event.metaKey || event.ctrlKey) && event.key === "k") {
      event.preventDefault();
      this.openSearch();
    }
    if ((event.metaKey || event.ctrlKey) && event.key === "b") {
      event.preventDefault();
      this.toggle();
    }
  }

  openSearch() {
    const searchElement = document.querySelector('[data-controller*="search"]');
    if (searchElement) {
      const searchController =
        this.application.getControllerForElementAndIdentifier(
          searchElement,
          "search",
        );
      if (searchController && searchController.open) {
        searchController.open();
      }
    }
  }

  disconnect() {
    if (this.mediaQuery) {
      this.mediaQuery.removeListener(this.handleMediaQuery.bind(this));
    }
    document.removeEventListener(
      "keydown",
      this.handleKeyboardShortcut.bind(this),
    );
  }
}
