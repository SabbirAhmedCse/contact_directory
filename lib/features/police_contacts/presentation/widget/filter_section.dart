import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../resources/colors/app_colors.dart';
import '../../../../resources/style/app_style.dart';
import '../../../core/presentation/widgets/common_dropdown.dart';
import '../../domain/entities/units.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key, 
    required this.units,
    required this.selectedUnit,
    required this.subUnits,
    required this.selectedSubUnit,
    required this.subSubUnits,
    required this.selectedSubSubUnit,
    required this.onUnitChanged,
    required this.onSubUnitChanged,
    required this.onSubSubUnitChanged,
    required this.color,
    required this.style,
  });

  final List<Unit> units;
  final Unit? selectedUnit;
  final List<Unit> subUnits;
  final Unit? selectedSubUnit;
  final List<Unit> subSubUnits;
  final Unit? selectedSubSubUnit;
  final ValueChanged<Unit?> onUnitChanged;
  final ValueChanged<Unit?> onSubUnitChanged;
  final ValueChanged<Unit?> onSubSubUnitChanged;
  final AppColors color;
  final AppTextStyle style;

  @override
  Widget build(BuildContext context) {
    if (selectedUnit == null || subUnits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Filter by sub-unit',
          style: style.w600s14(color.primaryTextColor),
        ),
        Gap(10.h),
        Row(
          children: <Widget>[
            Expanded(
              child: CommonDropdown<Unit>(
                label: 'Sub unit',
                initialValue: selectedSubUnit,
                items: subUnits
                    .map(
                      (Unit unit) => DropdownMenuItem<Unit>(
                        value: unit,
                        child: Text(
                          unit.name,
                          overflow: TextOverflow.ellipsis,
                          style: style.w500s14(color.primaryTextColor),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onSubUnitChanged,
              ),
            ),
            if (selectedSubUnit != null && subSubUnits.isNotEmpty) ...[
              Gap(12.w),
              Expanded(
                child: CommonDropdown<Unit>(
                  label: 'Sub sub unit',
                  initialValue: selectedSubSubUnit,
                  items: subSubUnits
                      .map(
                        (Unit unit) => DropdownMenuItem<Unit>(
                          value: unit,
                          child: Text(
                            unit.name,
                            overflow: TextOverflow.ellipsis,
                            style: style.w500s14(color.primaryTextColor),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onSubSubUnitChanged,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
