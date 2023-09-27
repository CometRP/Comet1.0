import { onMount, onDestroy } from "svelte";
import xHairStore from '../stores/xHairStore';


interface nuiMessage {
  data: {
    action: string,
    topic?: string,
    [key: string]: any,
  },
}

export function EventHandler() {
  function mainEvent(event: nuiMessage) {
    switch (event.data.action) {
      case "xhairShow":
        xHairStore.setShow(true);
        break;
      case "xhairHide":
        xHairStore.setShow(false);
        break;
    }
  }

  onMount(() => window.addEventListener("message", mainEvent));
  onDestroy(() => window.removeEventListener("message", mainEvent));
}

export function handleKeyUp(event) {
  const charCode = event.key;
  if (charCode == "Escape") {
  }
}