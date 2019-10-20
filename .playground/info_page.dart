import 'package:flutter/material.dart';

import '../pages/map_screen.dart';
import '../pages/registration_page.dart';
import '../utils/style.dart';

import '../providers/location_provider.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    const double _kToolbarHeight = 56.0;
    final double _chartAnimationDuration = 0.0;
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(-25.974509, 32.5732966);

    LinearGradient _buildBackgroundGradient(BuildContext context) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        //stops: [0.2, 0.7],
        colors: [
          Colors.transparent,
          const Color(0xFF2E071B),
        ],
        tileMode: TileMode.clamp,
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (_deviceHeight - _statusBarHeight) * .5,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/runner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Hero(
                  tag: 'nelson',
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: _buildBackgroundGradient(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  height: 60,
                  width: 60,
                  child: Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsets.all(12),
                      child: Image.asset('assets/absa.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: _deviceHeight * .2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '2ª Meia Maratona',
                        textAlign: TextAlign.center,
                        style: AbsaStyle.headingStyle.copyWith(fontSize: 30),
                      ),
                      Text(
                        'Internacional de Maputo',
                        textAlign: TextAlign.center,
                        style: AbsaStyle.headingStyle.copyWith(fontSize: 30),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegistrationPage.routeName);
                      },
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Registar-se',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            //color: Colors.amber,
            width: double.infinity,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Uma corrida sem igual',
                  style: AbsaStyle.headingStyle2.copyWith(
                      color: Color(
                        0xFF2d2323,
                      ),
                      fontSize: 26),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Dia 07 de Setembro de 2019 vem a Moçambique participar numa grande meia maratona pelas belas estradas de Maputo, uma prova que não vais esquecer seja a correr ou a caminhar!',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.track_changes,
                          color: Color(0xFFf52d28),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Meia Maratona - 21.0975 Km',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Color(0xFFf05a78),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Corrida da Familia - 5 Km',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Color(0xFF870a3c),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Cerca de 3000 atletas',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    /* ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.track_changes),
                        title: Text(
                          'Meia Maratona - 21.0975 Km',
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.favorite),
                        title: Text(
                          'Corrida da Familia - 5 Km',
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.people),
                        title: Text(
                          'Cerca de 3000 atletas',
                        ),
                      ), */
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Percursos',
                    textAlign: TextAlign.center,
                    style: AbsaStyle.headingStyle2
                        .copyWith(color: Colors.black54, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Meia maratona'),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          splashColor: Colors.red,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => MapScreen(
                                  runningType: 'Meia Maratona',
                                  isFamily: false,
                                ),
                              ),
                            );
                            print('Meia maratona');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(seconds: 2),
                              fadeInCurve: Curves.bounceIn,
                              height: 150,
                              width: _deviceWidth * .4,
                              placeholder: 'assets/map_300_200.png',
                              image: staticMapImageUrl,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Corrida familia'),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => MapScreen(
                                  runningType: 'Corrida familia',
                                  isFamily: true,
                                ),
                              ),
                            );
                            print('Corrida familia');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(seconds: 2),
                              fadeInCurve: Curves.bounceIn,
                              height: 150,
                              width: _deviceWidth * .4,
                              placeholder: 'assets/map_300_200.png',
                              image: staticMapImageUrl,
                            ),
                            /* Image.network(
                                staticMapImageUrl,
                                width: _deviceWidth * .4,
                                fit: BoxFit.cover,
                                height: 150,
                              ) ,*/
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
