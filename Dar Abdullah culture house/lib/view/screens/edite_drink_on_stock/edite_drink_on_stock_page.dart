import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sized_context/sized_context.dart';
import 'package:worker_app/constant/text_style.dart';
import 'package:worker_app/view/widget/costum_text_field.dart';
import '../../../constant/fonts.dart';
import '../../../constant/server_const.dart';
import '../../../constant/sizes.dart';
import '../../../constant/status_request.dart';
import '../../../constant/theme.dart';
import '../../../data/Models/drink_model.dart';
import '../../../main.dart';
import '../../widget/divider_with_word.dart';
import '../../widget/general_input_text_field.dart';
import '../../widget/my_button.dart';
import '../../widget/no_internet_page.dart';
import 'edite_drink_on_stock_controller.dart';

// ignore: must_be_immutable
class EditeDrinkOnStockPage extends StatelessWidget {
  final EditeDrinkOnStockController controller = Get.find();
  DrinkModel initModel;
  EditeDrinkOnStockPage(this.initModel, {super.key});
  @override
  Widget build(BuildContext context) {
    controller.model = initModel;
    Sizes size = Sizes(context);
    return GetBuilder<EditeDrinkOnStockController>(
      builder: (ctx) => controller.statuseRequest ==
              StatuseRequest.offlinefailure
          ? noInternetPage(size, controller)
          : Form(
              key: controller.formstate,
              child: Container(
                height: Get.size.height * .95,
                width: context.widthInches > 5.5 ? 400 : Get.size.width * .95,
                color: Get.isDarkMode ? Colors.black54 : skinColorWhite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      createAppBar(size),
                      SizedBox(
                        height: sharedPreferences!.getString('lang') == 'en'
                            ? Get.size.height * .02
                            : Get.size.height * .01,
                      ),
                      dividerWithWord(
                        'Enter the new drink information'.tr,
                        icon: Icon(
                          Icons.no_drinks,
                          color:
                              Get.isDarkMode ? darkPrimaryColor : primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      generalInputTextFeild(
                          size,
                          Icons.no_drinks,
                          'Drink name'.tr,
                          (value) {
                            controller.name = value!;
                          },
                          TextInputType.name,
                          (value) {
                            if (value!.length < 3) {
                              return "The name is shourt".tr;
                            }
                            return null;
                          },
                          inialValue: initModel.name),
                      generalInputTextFeild(
                          size,
                          Icons.money,
                          'unit price'.tr,
                          (value) {
                            controller.price = value!;
                          },
                          TextInputType.number,
                          (value) {
                            value = value!.trim();

                            // Check if the price is a valid number
                            if (double.tryParse(value) == null) {
                              return "the price is not valid";
                            }

                            // Check if the price is non-negative
                            double price = double.parse(value);
                            if (price < 0) {
                              return "the price can not be less the 0";
                            }

                            // Price is valid
                            return null;
                          },
                          inialValue: initModel.price.toString()),
                      generalInputTextFeild(
                          size,
                          Icons.money,
                          'Total cost'.tr,
                          (value) {
                            controller.totalcost = value!;
                          },
                          TextInputType.number,
                          (value) {
                            value = value!.trim();

                            // Check if the price is a valid number
                            if (double.tryParse(value) == null) {
                              return "the cost is not valid";
                            }

                            // Check if the price is non-negative
                            double price = double.parse(value);
                            if (price < 0) {
                              return "the cost can not be less the 0";
                            }

                            // Price is valid
                            return null;
                          },
                          inialValue: initModel.cost.toString()),
                      generalInputTextFeild(
                          size,
                          Icons.bubble_chart_rounded,
                          'Avilable amount'.tr,
                          (value) {
                            controller.aviableAmount = value!;
                          },
                          TextInputType.number,
                          (value) {
                            value = value!.trim();

                            // Check if the price is a valid number
                            if (double.tryParse(value) == null) {
                              return "the aviable amount is not valid";
                            }

                            // Check if the price is non-negative
                            double price = double.parse(value);
                            if (price < 0) {
                              return "the aviable amount can not be less the 0";
                            }

                            // Price is valid
                            return null;
                          },
                          inialValue: initModel.quantity.toString()),
                      generalInputTextFeild(
                          size,
                          Icons.info,
                          'description'.tr,
                          (value) {
                            controller.description = value!;
                          },
                          TextInputType.text,
                          (value) {
                            if (value!.length < 5) {
                              return "The description is not valid".tr;
                            }
                            return null;
                          },
                          inialValue: initModel.description),
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.pickImage();
                        },
                        child: Text(
                          'Select the drink image'.tr,
                          style: generalTextStyle(null),
                        ),
                      ),
                      const SizedBox(height: 5),
                      controller.imageExcist
                          ? /*GetPlatform.isWeb
                            ? */
                          Image.file(
                              controller.image,
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              "${ServerConstApis.loadImages}${initModel.image}",
                              fit: BoxFit.fill),
                      const SizedBox(
                        height: 15,
                      ),
                      addAButton(size),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ),
    );
  }

/*    dividerWithWord(
                'Enter the new information'.tr,
              ),
              const SizedBox(height: 30),
              editeDrinkInfoTextField(size, 'drink name', drink.name,
                  const Icon(Icons.wine_bar), TextInputType.name),
              const SizedBox(height: 30),
              editeDrinkInfoTextField(
                  size,
                  'available amount',
                  drink.unitPriceInSP
                      .toString() /*I forget to add available amount to the drink model that I created but I think it's fine you can do it. */,
                  const Icon(Icons.local_drink),
                  TextInputType.number),
              const SizedBox(height: 30),
              editeDrinkInfoTextField(
                  size,
                  'drink price',
                  drink.unitPriceInSP.toString(),
                  const Icon(Icons.money_rounded),
                  TextInputType.number),
              const SizedBox(height: 30),
              //to do................................
              const SizedBox(
                height: 5,
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text(
                  'Select the drink image'.tr,
                  style: generalTextStyle(null),
                ),
              ),
              const SizedBox(height: 5),
              controller.webImageExcist
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: /*GetPlatform.isWeb
                            ? */
                          Image.memory(
                        controller.selectedImageInBytes,
                        fit: BoxFit.contain,
                      )
                      /* : Image.file(
                                File(controller.selectedImage.value),
                                fit: BoxFit.contain,
                              ),*/
                      )
                  : const SizedBox(),

              //to do................................
              SizedBox(
                height: Get.size.height * .35,
              ),
          */

  Widget addAButton(Sizes size) {
    return MyButton(
      myRadius: 5,
      mywidth: size.wideNormalButtonWidth,
      myheight: size.normalButtonHeight,
      mycolor: Get.isDarkMode ? darkPrimaryColor : primaryColor,
      ontap: () {
        controller.onPressDone();
      },
      child: AutoSizeText(
        'Done'.tr,
        style: TextStyle(
          fontSize: size.wideNormalButtonTextSize,
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
        ),
      ),
    );
  }

  Widget editeDrinkInfoTextField(Sizes size, String hintText, String label,
      Widget prefixIcon, TextInputType inputType) {
    return CostumTextField(
      inputtype: inputType,
      labelStyle: TextStyle(
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      widthOnTheScreen: size.textFieldWidth,
      onsaved: (value) {},
      hint: hintText.tr,
      hintStyle: TextStyle(
          fontFamily: jostFontFamily,
          color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor),
      label: label.tr,
      prefixIcon: prefixIcon,
      sucer: false,
    );
  }

  Padding createAppBar(Sizes size) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: sharedPreferences!.getString('lang') == 'en'
              ? Get.size.width * .01
              : 0),
      child: SizedBox(
        width: Get.size.width * .7,
        child: Text('Edite the drink info'.tr,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontFamily: jostFontFamily,
              fontSize: 30,
              color: Get.isDarkMode ? skinColorWhite : backGroundDarkColor,
            )),
      ),
    );
  }
}
