import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:take_home_test/presentation/cubit/cubit.dart';
import 'package:take_home_test/presentation/widgets/widgets.dart';

class TakeHomeView extends StatelessWidget {
  const TakeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<TakeHomeCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocSelector<TakeHomeCubit, TakeHomeState, bool>(
                  selector: (state) => state is TakeHomeLoading,
                  builder: (context, isLoading) => UrlInputWidget(
                    isLoading: isLoading,
                    onSubmit: BlocProvider.of<TakeHomeCubit>(context).shortenUrl,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recently shortened URLs',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Expanded(
                  child: BlocConsumer<TakeHomeCubit, TakeHomeState>(
                    listener: (context, state) {
                      if (state is TakeHomeError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.aliases.isEmpty) return const SizedBox.shrink();
                      return ListView.builder(
                        itemCount: state.aliases.length,
                        itemBuilder: (context, index) =>
                            AliasListItemWidget(alias: state.aliases[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
