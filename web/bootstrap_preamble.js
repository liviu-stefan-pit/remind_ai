(function () {
  'use strict';
  // Prepended to flutter_bootstrap.js on every deploy. Triggers an SW update
  // fetch (network-only) so Clear-Site-Data on flutter_service_worker.js can run.
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistrations().then(function (regs) {
      regs.forEach(function (reg) {
        reg.update();
      });
    });
  }
})();
