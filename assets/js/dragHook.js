import Sortable from 'sortablejs';

export default {
  mounted() {

    let dragged; // this will change so we use `let`

    const hook = this;

    const selector = '#' + this.el.id;

    tweetsDropzone = document.querySelector('[data-dropzone="tweets"]');
    issueDropzone = document.querySelector('[data-dropzone="issue"]');

    new Sortable(tweetsDropzone, {
        animation: 0,
        delay: 50,
        delayOnTouchOnly: true,
        group: {
          name: 'shared',
          pull: 'clone',
          put: false
        },
        draggable: '.js-draggable',
        ghostClass: 'sortable-ghost',
        onEnd: function(evt) {
          hook.pushEvent('tweet_dropped', {
            tweet_id: evt.item.id, // id of the dragged item
            index: evt.newDraggableIndex, // index where the item was dropped (relative to other items in the drop zone)
          })
        }
      });

    new Sortable(issueDropzone, {
        animation: 0,
        delay: 50,
        delayOnTouchOnly: true,
        group: {
          name: 'shared',
        },
        onEnd: function(evt) {
          alert("HEY");
          console.log("PUSHEVENT!")
          // hook.pushEvent('tweet_dropped', {
          //   tweet_id: evt.item.id, // id of the dragged item
          //   index: evt.newDraggableIndex, // index where the item was dropped (relative to other items in the drop zone)
          // })
        },
        draggable: '.js-draggable',
        ghostClass: 'sortable-ghost',
      });
  }
};