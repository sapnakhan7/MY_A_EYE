import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'view_labels_dialog_model.dart';

class ViewLabelsDialog extends StackedView<ViewLabelsDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ViewLabelsDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ViewLabelsDialogModel viewModel,
    Widget? child,
  ) {
    var data = request.data;
    String name = "";
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AppColors.backgoundColorDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 0.7.sh,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Saved Faces',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              verticalSpaceLarge,
              ListView.separated(
                  padding: const EdgeInsets.all(2),
                  separatorBuilder: (BuildContext context, int index) =>
                      10.verticalSpace,
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    name = data.keys.elementAt(index);
                    return ListTile(
                      selected: true,
                      selectedTileColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ViewLabelsDialogModel viewModelBuilder(BuildContext context) =>
      ViewLabelsDialogModel();
}
