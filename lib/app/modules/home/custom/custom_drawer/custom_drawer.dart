import 'package:flutter/material.dart';

import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerTile(iconData:  Icons.home, title: "Início",page: 0),
          DrawerTile(iconData:  Icons.list, title: "Produtos",page: 1),
          DrawerTile(iconData:  Icons.playlist_add_check, title: "Meus Pedidos",page: 2,),
          DrawerTile(iconData:  Icons.location_on, title: "Lojas",page: 3,),
          DrawerTile(iconData:  Icons.logout, title: "Sair",),
        ],
      ),
    );
  }
}
