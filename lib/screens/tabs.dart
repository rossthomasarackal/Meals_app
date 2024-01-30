import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filtersScreen.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

import '../models/meal.dart';
const kInitialFilter=  {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};
class TabScreen extends StatefulWidget {
 const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Map<Filter, bool> _selectedFilters = kInitialFilter;

  void _showInfoMessage(String message){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message)));
  }

  int _selectedPageIndex=0;
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }

  final List<Meal> _favoriteMeal=[];

  void _toggleMealFavoriteStatus(Meal meal){
    final isExisting = _favoriteMeal.contains(meal);
    if(isExisting){
      setState(() {
        _favoriteMeal.remove(meal);
      });
      _showInfoMessage('Item removed from Favorite');
    }
    else{
      setState(() {
        _favoriteMeal.add(meal);
      });
      _showInfoMessage('Item added to Favorite');
    }
  }

  void _setScreen(String identifier) async {

    Navigator.of(context).pop();

    if(identifier=='Filters'){
    final result = await Navigator.of(context).push<Map<Filter, bool >>(
        MaterialPageRoute(builder: (ctx)=>
            FiltersScreen(currentFilters: _selectedFilters),
        ));
    // print(result);
       setState(() {
         _selectedFilters= result ?? kInitialFilter;
       });
    }
  }
  @override
  Widget build(BuildContext context) {
    final availableMeals= dummyMeals.where((meal) {
        if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
          return false; }

        if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
          return false; }

        if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
          return false; }

        if(_selectedFilters[Filter.vegan]! && !meal.isVegan) {
          return false; }
        return true;
    }
    ).toList();
    Widget activeScreen = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );

    var activePageTitle='Categories';
    if(_selectedPageIndex==1 ){
        activeScreen=  MealsScreen(
            meals: _favoriteMeal,
            onToggleFavorite: _toggleMealFavoriteStatus
        );
        activePageTitle= 'Your Favorites';
    }


    return Scaffold(
      appBar: AppBar(title:Text(activePageTitle),),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
