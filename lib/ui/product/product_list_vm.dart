import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/ui/product/product_list.dart';
import 'package:invoiceninja/redux/app/app_state.dart';
import 'package:invoiceninja/redux/product/product_state.dart';
import 'package:invoiceninja/redux/product/product_actions.dart';
import 'package:invoiceninja/ui/product/product_details_vm.dart';


class ProductListBuilder extends StatelessWidget {
  ProductListBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductListVM>(
      converter: ProductListVM.fromStore,
      builder: (context, vm) {
        return ProductList(
          viewModel: vm,
        );
      },
    );
  }
}

class ProductListVM {
  final ProductState productState;
  final bool isLoading;
  final Function(BuildContext, ProductEntity) onProductTap;
  final Function(BuildContext, ProductEntity, DismissDirection) onDismissed;

  ProductListVM({
    @required this.productState,
    @required this.isLoading,
    @required this.onProductTap,
    @required this.onDismissed,
  });

  static ProductListVM fromStore(Store<AppState> store) {
    return ProductListVM(
      productState: store.state.productState(),
      /*
      products: filteredProductsSelector(
        productsSelector(store.state),
        //activeFilterSelector(store.state),
      ),
      */
      isLoading: store.state.productState().lastUpdated == 0,
      onProductTap: (context, product) {
        store.dispatch(SelectProductAction(product));
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailsBuilder()));
      },
      onDismissed: (BuildContext context, ProductEntity product, DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          store.dispatch(ArchiveProductRequest(context, product.id));
        } else if (direction == DismissDirection.startToEnd) {
          store.dispatch(DeleteProductRequest(context, product.id));
        }
      }
    );
  }
}
