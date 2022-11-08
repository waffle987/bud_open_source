import 'dart:io';

import 'package:bud/general/categories.dart';
import 'package:bud/general/recommendations.dart';
import 'package:bud/general/ui/loading_page.dart';
import 'package:bud/general/widgets/circle_back_button.dart';
import 'package:bud/general/widgets/expansion_list.dart';
import 'package:bud/general/widgets/rounded_button.dart';
import 'package:bud/post_pages/controllers/upload_post_controller.dart';
import 'package:bud/post_pages/widgets/category_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../general/config.dart';
import '../../general/controllers/image_picker_controller.dart';
import '../../general/widgets/text_input_field.dart';

class UploadPostPage extends StatelessWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    /// GetX controllers
    final UploadPostController uploadPostController =
        Get.put<UploadPostController>(UploadPostController());
    final ImagePickerController imagePickerController =
        ImagePickerController.to;

    /// Build the text field section
    Widget textFieldSection({
      required String title,
      required TextEditingController textEditingController,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                color: kNavyBlueColour,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            TextInputField(
              controller: textEditingController,
              fillColour: kLightGreyColour,
            )
          ],
        ),
      );
    }

    /// Build recommendation row
    Widget buildEmojiWheel() {
      /// Emoji design
      Widget emojiDesign({
        required IconData iconData,
        required Color colour,
        required String type,
      }) {
        return Obx(() => GestureDetector(
              onTap: () => uploadPostController.recommendation.value = type,
              child: CircleAvatar(
                backgroundColor: colour,
                radius: uploadPostController.recommendation.value == type
                    ? mediaQuery.size.width * 0.10
                    : mediaQuery.size.width * 0.07,
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: uploadPostController.recommendation.value == type
                      ? mediaQuery.size.width * 0.10
                      : mediaQuery.size.width * 0.07,
                ),
              ),
            ));
      }

      return SizedBox(
        height: mediaQuery.size.height * 0.10,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              emojiDesign(
                iconData: FontAwesomeIcons.solidThumbsUp,
                colour: kNavyBlueColour,
                type: Recommendations.thumbsUp,
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              emojiDesign(
                iconData: FontAwesomeIcons.solidFaceSmileBeam,
                colour: kPrimaryAccentColour,
                type: Recommendations.happyFace,
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              emojiDesign(
                iconData: FontAwesomeIcons.solidHeart,
                colour: Colors.pinkAccent,
                type: Recommendations.heart,
              ),
              SizedBox(width: mediaQuery.size.width * 0.02),
              emojiDesign(
                iconData: FontAwesomeIcons.solidThumbsDown,
                colour: Colors.red,
                type: Recommendations.thumbsDown,
              ),
            ],
          ),
        ),
      );
    }

    /// Build selected image row
    Widget buildSelectedImageRow() {
      return Obx(() => imagePickerController.selectedImages.value!.isNotEmpty
          ? Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.03),
                SizedBox(
                  height: mediaQuery.size.height * 0.20,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.size.width * 0.05),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          imagePickerController.selectedImages.value!.length,
                      itemBuilder: (BuildContext context, int index) {
                        File file = File(imagePickerController
                            .selectedImages.value![index].path);

                        return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.size.width * 0.01),
                            child: Image.file(file));
                      }),
                ),
              ],
            )
          : Container());
    }

    /// Build category row
    Widget buildCategoryRow() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.10),
        child: Obx(() => uploadPostController.categoryList.isNotEmpty
            ? SizedBox(
                height: mediaQuery.size.height * 0.055,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: uploadPostController.categoryList.length,
                    itemBuilder: (BuildContext context, int index) => Row(
                          children: [
                            CategoryTab(
                              category:
                                  uploadPostController.categoryList[index],
                              textFontSize: mediaQuery.size.width * 0.035,
                              trailingWidget: Row(
                                children: [
                                  SizedBox(width: mediaQuery.size.width * 0.03),
                                  GestureDetector(
                                    onTap: () =>
                                        uploadPostController.removeCategory(
                                            category: uploadPostController
                                                .categoryList[index]),
                                    child: Icon(
                                      FontAwesomeIcons.x,
                                      size: mediaQuery.size.width * 0.03,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: mediaQuery.size.width * 0.02),
                          ],
                        )),
              )
            : Container()),
      );
    }

    return Stack(
      children: [
        Obx(() => uploadPostController.isLoading.value
            ? const LoadingPage()
            : Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: kNavyBlueColour,
                  onPressed: () => uploadPostController.postRecommendation(),
                  child: const Icon(FontAwesomeIcons.check),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.01),
                        Text(
                          "Create Post",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kNavyBlueColour,
                          ),
                        ),
                        buildSelectedImageRow(),
                        SizedBox(height: mediaQuery.size.height * 0.05),
                        RoundedButton(
                          buttonText: "Upload Pics",
                          buttonColour: kPrimaryAccentColour,
                          buttonFontSize: 15,
                          onPressed: () => imagePickerController
                              .selectMultipleImagesFromGallery(),
                          buttonHeight: mediaQuery.size.width * 0.10,
                          buttonLength: mediaQuery.size.width * 0.40,
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.05),
                        buildEmojiWheel(),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.size.width * 0.10),
                          child: ExpansionList(
                            items: const [
                              Categories.food,
                              Categories.beauty,
                              Categories.lifestyle,
                              Categories.sports,
                              Categories.outdoors,
                            ],
                            title: "Select Category",
                            onItemSelected: (category) => uploadPostController
                                .updateCategoryList(category: category),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        buildCategoryRow(),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        textFieldSection(
                          title: "Title",
                          textEditingController:
                              uploadPostController.nameTextEditingController,
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        textFieldSection(
                          title: "Your thoughts",
                          textEditingController: uploadPostController
                              .descriptionTextEditingController,
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              )),
        Obx(() => uploadPostController.isLoading.value
            ? Container()
            : const CircleBackButton()),
      ],
    );
  }
}
