import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealDetailsScreen extends StatelessWidget{
  const MealDetailsScreen({super.key, required this.meal, required this.onToggleFavorite});
  final Meal meal;
  final void Function(Meal meal ) onToggleFavorite;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title ),
        actions: [
          IconButton(
              onPressed: (){
                onToggleFavorite(meal);
              },
              icon: const Icon(Icons.star),
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                meal.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 250),
            const SizedBox(height: 10),
            Text('Ingredients', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
              fontWeight: FontWeight.bold
            ),),

            const SizedBox(height: 10),
            for(final ingredient in meal.ingredients)
               Text(ingredient, style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                   color: Theme.of(context).colorScheme.onBackground
               ),),

            const SizedBox(height: 10),
            Text('Steps', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
                fontWeight: FontWeight.bold
            ),),

            const SizedBox(height: 10),
            for(final step in meal.steps)
              Padding(padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal:12 ),

                child: Text(step, style:Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                  textAlign: TextAlign.center,),
              )


          ],
        ),
      ),

    );
  }
}