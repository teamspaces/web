// Adding path as the main path is incorrect in the package
import '../../../vendor/assets/javascripts/jquery.mjs.nestedSortable'

class PageTree {

  constructor({container, onChange}) {
    this.container = container;
    this.onChange = onChange;

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

export default PageTree;
