import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery
console.log('insex here');

document.addEventListener('turbo:load', function() {
  $('#tariff-button').off('click').on('click', function() {
    const button = $('#tariff-button');
    const block = $('#tariff-block');

    if (button.text() == 'Cкрыть') {
      block.hide();
      button.text('Показать');
    } else {
      block.show();
      button.text('Cкрыть');
    }
  });
})
