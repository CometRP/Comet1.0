<script lang="ts">
  import { EventHandler } from './utils/eventHandler';
  import xHairStore from './stores/xHairStore';

  const { show } = xHairStore;

  EventHandler();
</script>


{#if $show}
  <main class="min-h-screen">
    <div style="width: 100vw; height: 100vh; position: fixed; top: 0; left: 0; display: flex; align-items: center; justify-content: center;">
      <div id="xhair" style="display: block; border-radius: 100%; border: 1px solid black; width: 5px; height: 5px; background-color: white">
      </div>
    </div>
  </main>
{/if}