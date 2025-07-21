<template>
  <!-- The main navigation bar container with the animated border -->
  <nav class="relative p-1 rounded-xl overflow-hidden animated-border-container shadow-lg w-full">
    <!-- Inner div for the actual navigation content, providing the solid background -->
    <div class="bg-gray-800 p-4 rounded-xl">
      <!-- No content inside for now, as requested -->
      <div>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'NavBar',
  data() {
    return {
      isOpen: false, // State to control mobile menu visibility (not used currently, but kept for future expansion)
    };
  },
  methods: {
    toggleMenu() {
      this.isOpen = !this.isOpen; // Toggle the menu state (not used currently)
    },
  },
};
</script>

<style scoped>
/* Custom CSS for the wave animation on the border */
.animated-border-container {
  /* Define the gradient for the border with more colors */
  background: linear-gradient(to right, #ef4444, #f97316, #eab308, #22c55e, #06b6d4, #3b82f6, #6366f1, #a855f7, #ef4444);
  /* Make the background wider than the element to allow movement */
  background-size: 200% 100%;
  /* Apply the animation */
  animation: border-wave-animation 8s linear infinite; /* Adjusted animation duration for smoother flow with more colors */
}

@keyframes border-wave-animation {
  0% {
    background-position: 0% 50%; /* Start position of the gradient */
  }
  100% {
    background-position: 100% 50%; /* End position of the gradient, creating a wave effect */
  }
}
</style>
