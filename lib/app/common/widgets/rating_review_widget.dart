import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mh/app/common/extensions/extensions.dart';
import 'package:mh/app/common/style/my_decoration.dart';
import 'package:mh/app/common/values/my_color.dart';
import 'package:mh/app/common/widgets/custom_buttons.dart';
import 'package:mh/app/common/widgets/custom_network_image.dart';
import 'package:mh/app/enums/custom_button_style.dart';
import 'package:mh/app/modules/employee/employee_home/models/review_dialog_model.dart';

typedef OnRatingUpdate = void Function(double rating);
typedef OnReviewSubmit = void Function({required String id, required String reviewForId});
typedef OnCancelClick = void Function({required String id, required String reviewForId, required double manualRating});

class RatingReviewWidget extends StatelessWidget {
  final ReviewDialogDetailsModel reviewDialogDetailsModel;
  final OnRatingUpdate onRatingUpdate;
  final OnCancelClick onCancelClick;
  final TextEditingController tecReview;
  final OnReviewSubmit onReviewSubmit;
  final String reviewFor;

  const RatingReviewWidget(
      {super.key,
      required this.reviewFor,
      required this.onRatingUpdate,
      required this.onReviewSubmit,
      required this.onCancelClick,
      required this.reviewDialogDetailsModel,
      required this.tecReview});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                color: Colors.white),
            height: 380,
            child: Center(
                child: Column(
              children: [
                const SizedBox(height: 10),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: reviewFor == 'client'
                        ? reviewDialogDetailsModel.restaurantDetails?.profileImage ??
                            'https://logowik.com/content/uploads/images/restaurant9491.logowik.com.webp'
                        : (reviewDialogDetailsModel.employeeDetails?.profilePicture ?? '').imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 45 * 2,
                      height: 45 * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(), // Placeholder widget while loading
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image_not_supported_outlined), // Error widget if image fails to load
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                    reviewFor == 'client'
                        ? reviewDialogDetailsModel.restaurantDetails?.restaurantName ?? ''
                        : reviewDialogDetailsModel.employeeDetails?.name ?? '',
                    style: MyColors.l111111_dwhite(context).semiBold16),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: onRatingUpdate,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tecReview,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: null,
                  cursorColor: MyColors.c_C6A34F,
                  style: MyColors.l111111_dwhite(context).regular14,
                  decoration: MyDecoration.inputFieldDecoration(
                    context: context,
                    label: "Comment if any (optional)",
                  ),
                ),
                const SizedBox(height: 30),
                CustomButtons.button(
                  height: 48,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    onReviewSubmit(
                        id: reviewDialogDetailsModel.id ?? '',
                        reviewForId: reviewFor == 'client'
                            ? reviewDialogDetailsModel.restaurantDetails?.hiredBy ?? ''
                            : reviewDialogDetailsModel.employeeDetails?.employeeId ?? '');
                  },
                  text: "Submit",
                  customButtonStyle: CustomButtonStyle.radiusTopBottomCorner,
                ),
              ],
            ))),
        Positioned.fill(
            child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                onCancelClick(
                    id: reviewDialogDetailsModel.id ?? '',
                    reviewForId: reviewFor == 'client'
                        ? reviewDialogDetailsModel.restaurantDetails?.hiredBy ?? ''
                        : reviewDialogDetailsModel.employeeDetails?.employeeId ?? '',
                    manualRating: 5.0);
              },
              child: const CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.red,
                child: Icon(Icons.clear, color: Colors.white, size: 20),
              ),
            ),
          ),
        ))
      ],
    );
  }
}
