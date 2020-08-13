import 'package:my_shop_with_firebase/models/product.dart';
import 'package:my_shop_with_firebase/screens/productAdd.dart';
import 'package:my_shop_with_firebase/screens/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductList extends StatefulWidget {
  State<StatefulWidget> createState() => ProductListState();
  
}

class ProductListState extends State {
  DbHelper dbHelper = new DbHelper();
  List<Product> products;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = new List<Product>();
      getData();
    }
    return Scaffold(
      body: productListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){goToProductAddition();},
        tooltip: "add new product",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.redAccent,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Text("A"),
            ),
            title: Text(this.products[position].name),
            subtitle: Text(this.products[position].description),
            onTap: (){
              goToDetail(this.products[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    var db = dbHelper.initializeDb();
    db.then((result){
      var productsFuture = dbHelper.getProducts();
      productsFuture.then((data){
        List<Product> productsData = new List<Product>();
        count = data.length;
        for (int i = 0; i < count; i++) {
          productsData.add(Product.fromObject(data[i]));
        }
        setState(() {
          products = productsData;
          count = count;
        });
      });
    });
  }

  void goToDetail(Product product) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(product)));
    if (result != null) {  // To ensure the data is not fetched when the product is deleted.
      if (result) {
        getData();
      }
    }
  }

  void goToProductAddition() async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context)=> ProductAdd()
    ));
    if (result != null) {
      if (result) {
        getData();
      }
    }
  }
}