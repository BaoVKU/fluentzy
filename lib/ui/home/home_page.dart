import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/data/enums/home_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final isMediumScreen = constraint.maxWidth > 600;
        final isLargeScreen = constraint.maxWidth > 1200;
        var columnCount = 2;
        if (isLargeScreen) {
          columnCount = 6;
        } else if (isMediumScreen) {
          columnCount = 3;
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: const Text('Home'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: columnCount,
                children:
                    HomeFeature.values.map((feature) {
                      return GestureDetector(
                        onTap:
                            () => {
                              switch (feature) {
                                HomeFeature.speaking => context.go(
                                  RoutePath.speakingLesson,
                                ),

                                HomeFeature.listening =>
                                  throw UnimplementedError(),
                                HomeFeature.scanner => context.go(
                                  RoutePath.scannerOptions,
                                ),
                                HomeFeature.flashCard =>
                                  throw UnimplementedError(),
                                HomeFeature.quiz => throw UnimplementedError(),
                                HomeFeature.translator =>
                                  throw UnimplementedError(),
                              },
                            },
                        child: Card(
                          color: feature.backgroundColor,
                          elevation: 4,
                          margin: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: SvgPicture.asset(
                                  feature.iconPath,
                                  width: 64,
                                  height: 64,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  feature.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
