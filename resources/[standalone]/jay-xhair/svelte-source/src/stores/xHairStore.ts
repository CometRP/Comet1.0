import { writable } from "svelte/store";
import type { Writable } from 'svelte/store';
import fetchNUI from '../utils/fetch';

interface xHairState {
  show: Writable<boolean>
}

const store = () => {
  const xHairStore: xHairState = {
    show: writable(false),
  }

  const methods = {
    setShow(show: boolean) {
        xHairStore.show.set(show);
    },
  }

  return {
    ...xHairStore,
    ...methods
  }
}

export default store();