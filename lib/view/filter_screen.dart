// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uday_interview/model/category_data_model.dart';
import 'package:uday_interview/model/subcategories_model.dart';
import 'package:uday_interview/network/api_manager.dart';
import 'package:uday_interview/response/category_response.dart';
import 'package:uday_interview/response/product_response.dart';
import 'package:uday_interview/utlis/app_api.dart';
import 'package:uday_interview/utlis/app_colors.dart';
import 'package:uday_interview/utlis/toast.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with TickerProviderStateMixin {
  late TabController tabBarController;
  final isLoading = ValueNotifier<bool>(false);
  final isPageLoading = ValueNotifier<bool>(false);
  final isMoreProductLoading = ValueNotifier<bool>(false);
  final categoryId = ValueNotifier<int>(0);
  final subCategoryIdNotifier = ValueNotifier<int>(0);
  final stopApi = ValueNotifier<bool>(false);
  final stopProductApi = ValueNotifier<bool>(false);
  List<CategoryDataModel> categoryList = [];
  List<SubCategoriesModel> subCategoryList = [];
  final page = ValueNotifier<int>(1);
  final productPage = ValueNotifier<int>(1);

  @override
  void initState() {
    getAllCategoriesApi();

    super.initState();
  }

  void _notify() {
    if (mounted) {
      setState(() {});
    }
  }

  void noDataLogic() {
    stopApi.value = false;
    page.value = page.value - 1;
  }

  void noDataProductLogic() {
    stopProductApi.value = false;
    if (productPage.value > 1) {
      productPage.value = productPage.value - 1;
    }
  }

  Future<void> getAllCategoriesApi({bool isFirstTimeCall = true}) async {
    try {
      if (await ApiManager.checkInternet()) {
        if (isFirstTimeCall) {
          categoryId.value = 0;
          isLoading.value = true;
        } else {
          isPageLoading.value = true;
        }

        final response = CategoryResponse.fromJson(await ApiManager().postCall(AppApi.getAllCategoriesUrl, {}, context));

        if (response.status == 200 &&
            response.result != null &&
            response.result!.category != null &&
            response.result!.category!.isNotEmpty) {
          tabBarController = TabController(length: response.result!.category!.length, vsync: this);
          categoryList.addAll(response.result!.category!);

          categoryId.value = response.result!.category!.first.id!;
          getSubcategoriesApi();
          _notify();
        } else {
          toast(text: "Something went wrong");
        }
        if (isFirstTimeCall) {
          isLoading.value = false;
        } else {
          isPageLoading.value = false;
        }
      } else {
        toast(text: "No internet");
      }
    } catch (e) {
      if (isFirstTimeCall) {
        isLoading.value = false;
      } else {
        isPageLoading.value = false;
      }
      log("Error $e");
    }
  }

  Future<void> getSubcategoriesApi({bool isFirstTimeCall = true}) async {
    try {
      if (await ApiManager.checkInternet()) {
        if (isFirstTimeCall) {
          isLoading.value = true;
        } else {
          isPageLoading.value = true;
        }
        final request = {
          "CategoryId": categoryId.value,
          "PageIndex": page.value.toString(),
        };
        final response = CategoryResponse.fromJson(await ApiManager().postCall(AppApi.getAllCategoriesUrl, request, context));

        if (response.status == 200 &&
            response.result != null &&
            response.result!.category != null &&
            response.result!.category!.isNotEmpty) {
          if (response.result!.category!.first.subCategories != null && (response.result!.category!.first.subCategories!.isNotEmpty)) {
            subCategoryList.addAll(response.result!.category!.first.subCategories!);
            page.value++;
            _notify();
          } else {
            noDataLogic();
          }
        } else {
          toast(text: "Something went wrong");
        }
        if (isFirstTimeCall) {
          isLoading.value = false;
        } else {
          isPageLoading.value = false;
        }
      } else {
        toast(text: "No internet");
      }
    } catch (e) {
      if (isFirstTimeCall) {
        isLoading.value = false;
      } else {
        isPageLoading.value = false;
      }
      log("Error $e");
    }
  }

  Future<void> getProductsApi({required String subCategoryId}) async {
    if (await ApiManager.checkInternet()) {
      isMoreProductLoading.value = true;

      if (subCategoryIdNotifier.value.toString() != subCategoryId) {
        subCategoryIdNotifier.value = int.tryParse(subCategoryId) ?? 0;
        productPage.value = 2;
      }
      final request = {
        "PageIndex": productPage.value.toString(),
        "SubCategoryId": subCategoryIdNotifier.value.toString(),
      };

      final response = ProductResponse.fromJson(
        await ApiManager().postCall(AppApi.getProductUrl, request, context),
      );

      if (response.status == 200 && response.result != null && response.result!.isNotEmpty) {
        subCategoryList = subCategoryList.mapIndexed((index, element) {
          if (element.id.toString() == subCategoryId) {
            return element.copyWith(product: [...element.product ?? [], ...response.result!]);
          }
          return element;
        }).toList();

        productPage.value++;
      } else {
        noDataProductLogic();
      }
      isMoreProductLoading.value = false;
      _notify();
    } else {
      toast(text: "No internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Uday practical"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: AppColors.whiteColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              if (categoryList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  color: AppColors.blackColor,
                  child: TabBar(
                    controller: tabBarController,
                    isScrollable: true,
                    physics: const NeverScrollableScrollPhysics(),
                    labelColor: AppColors.whiteColor,
                    indicator: const BoxDecoration(color: AppColors.transparentColor),
                    unselectedLabelColor: AppColors.whiteColor.withOpacity(0.5),
                    indicatorColor: AppColors.transparentColor,
                    dividerColor: AppColors.transparentColor,
                    tabAlignment: TabAlignment.center,
                    onTap: (index) {
                      if (categoryList[index].id != null) {
                        categoryId.value = categoryList[index].id!;
                        page.value = 1;
                        subCategoryList.clear();
                        _notify();
                        getSubcategoriesApi();
                      }
                    },
                    tabs: List.generate(
                      categoryList.length,
                      (index) => Tab(
                        text: categoryList[index].name ?? "",
                      ),
                    ),
                  ),
                ),
              if (categoryList.isNotEmpty)
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabBarController,
                    children: List.generate(
                      categoryList.length,
                      (index) => tabBarView(screenHeight: screenHeight),
                    ),
                  ),
                ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, _) {
              if (value) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget tabBarView({required double screenHeight}) {
    if (subCategoryList.isNotEmpty) {
      return ListView.builder(
        itemCount: subCategoryList.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return subCategoryList.length - 1 == index
              ? VisibilityDetector(
                  key: Key(index.toString()),
                  child: Column(
                    children: <Widget>[
                      categoryDataWidget(screenHeight: screenHeight, index: index, subCategories: subCategoryList),
                      ValueListenableBuilder<bool>(
                          valueListenable: isPageLoading,
                          builder: (context, value, _) {
                            if (value) {
                              return const Column(
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                ],
                              );
                            }
                            return const SizedBox();
                          })
                    ],
                  ),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (index == subCategoryList.length - 1 && !stopApi.value) {
                      getSubcategoriesApi(isFirstTimeCall: false);
                    }
                  },
                )
              : categoryDataWidget(
                  screenHeight: screenHeight,
                  index: index,
                  subCategories: subCategoryList,
                );
        },
      );
    }
    return const SizedBox();
  }

  Widget categoryDataWidget({required double screenHeight, required List<SubCategoriesModel> subCategories, required int index}) {
    if (subCategories.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subCategories[index].name ?? "",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.blackColor),
          ),
          const SizedBox(height: 8),
          if (subCategories[index].product != null && subCategories[index].product!.isNotEmpty)
            SizedBox(
              height: screenHeight * 0.18, // Adjusted height using MediaQuery
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: subCategories[index].product?.length ?? 0,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                padding: const EdgeInsets.only(right: 8),
                itemBuilder: (context, innerIndex) => (subCategories[index].product?.length ?? 0) - 1 == innerIndex
                    ? VisibilityDetector(
                        key: Key(innerIndex.toString()),
                        child: Row(
                          children: <Widget>[
                            productView(
                              screenHeight: screenHeight,
                              index: index,
                              subCategories: subCategories,
                              innerIndex: innerIndex,
                            ),
                            ValueListenableBuilder<bool>(
                                valueListenable: isMoreProductLoading,
                                builder: (context, value, _) {
                                  if (value) {
                                    return const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(width: 10),
                                        Center(child: CircularProgressIndicator()),
                                        SizedBox(width: 10),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                })
                          ],
                        ),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (!stopProductApi.value && innerIndex == subCategories[index].product!.length - 1) {
                            if (subCategories[index].product?[innerIndex].id != null) {
                              getProductsApi(subCategoryId: subCategories[index].id.toString());
                            }
                          }
                        },
                      )
                    : productView(
                        screenHeight: screenHeight,
                        index: index,
                        subCategories: subCategories,
                        innerIndex: innerIndex,
                      ),
              ),
            ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget productView(
      {required double screenHeight, required int index, required List<SubCategoriesModel> subCategories, required int innerIndex}) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    subCategories[index].product?[innerIndex].imageName ?? "",
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenHeight * 0.15),
              child: Text(
                subCategories[index].product?[innerIndex].name ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 12, color: AppColors.blackColor),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            subCategories[index].product?[innerIndex].priceCode ?? "",
            style: const TextStyle(color: AppColors.whiteColor),
          ),
        )
      ],
    );
  }
}
