'use strict';

const PageTree = class PageTree {

  constructor(options) {
    this.container = options.container;
    this.onChange = options.onChange;

    this.init();
  };

  init(){
    this.container.nestedSortable({
      handle: 'a',
      items: 'li',
      listType: 'ul',
      toleranceElement: '> a',
      isTree: true,
      relocate: this.relocate.bind(this)
    });
  };

  relocate(){
    var hierarchy = this.container.sortable('toHierarchy');

    this.onChange(hierarchy);
  };
};

module.exports = PageTree;
