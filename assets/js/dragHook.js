import Sortable from 'sortablejs';

export default {
  mounted() {

    let dragged; // this will change so we use `let`

    const hook = this;

    const selector = '#' + this.el.id;

    tweetsDropzone = document.querySelector('[data-dropzone="tweets"]');
    issueDropzone = document.querySelector('[data-dropzone="issue"]');

    new Sortable(tweetsDropzone, {
        animation: 150,
        delay: 50,
        delayOnTouchOnly: true,
        group: {
          name: 'shared',
          pull: 'clone',
        },
        draggable: '.js-draggable',
        ghostClass: 'bg-yellow-400',
        chosenClass: 'bg-purple-400',
        dragClass: 'bg-blue-300'
      });

    new Sortable(issueDropzone, {
        animation: 150,
        delay: 50,
        delayOnTouchOnly: true,
        group: {
          name: 'shared',
          pull: false
        },
        onAdd: function(evt) {
          hook.pushEvent('tweet_dropped', {
            tweet_id: evt.item.id, // id of the dragged item
            position: evt.newDraggableIndex, // index where the item was dropped
          })
        },
        onUpdate: function(evt) {
          hook.pushEvent('section_moved', {
            section_id: evt.item.id, // id of the moved section
            position: evt.newDraggableIndex, // index where the section was dropped
          })
        },
        draggable: '.js-draggable',
        ghostClass: 'bg-yellow-400',
        chosenClass: 'bg-purple-400',
        dragClass: 'bg-blue-300'
      });
  }
};