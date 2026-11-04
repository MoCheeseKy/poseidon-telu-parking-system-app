import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';
import 'package:poseidon/ui/core/widgets/vehicle_type_selector.dart';

class RegisteredVehiclesScreen extends StatefulWidget {
  final UserProfileStore? store;

  const RegisteredVehiclesScreen({
    super.key,
    this.store,
  });

  static MaterialPageRoute<void> route({UserProfileStore? store}) {
    return MaterialPageRoute<void>(
      builder: (_) => RegisteredVehiclesScreen(store: store),
    );
  }

  @override
  State<RegisteredVehiclesScreen> createState() =>
      _RegisteredVehiclesScreenState();
}

class _RegisteredVehiclesScreenState extends State<RegisteredVehiclesScreen> {
  UserProfileStore get _store =>
      widget.store ?? MockUserProfileData.sharedStore;

  void _openAddVehicleSheet() {
    final nameController = TextEditingController();
    final plateController = TextEditingController();
    final colorController = TextEditingController();
    VehicleType selectedType = VehicleType.motor;
    bool setPrimary = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: EdgeInsets.fromLTRB(
                20.0,
                8.0,
                20.0,
                MediaQuery.of(sheetContext).viewInsets.bottom + 24.0,
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DragHandle(),
                      const Text(
                        'Tambah Kendaraan',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      VehicleTypeSelector(
                        selectedType: selectedType,
                        onTypeChanged: (type) {
                          setSheetState(() => selectedType = type);
                        },
                      ),
                      const SizedBox(height: 14.0),
                      _buildSheetField(
                        label: 'Merk & Tipe',
                        hint: 'Contoh: Yamaha NMAX 155',
                        controller: nameController,
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSheetField(
                              label: 'Nomor Polisi',
                              hint: 'D 2025 TLU',
                              controller: plateController,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: _buildSheetField(
                              label: 'Warna',
                              hint: 'Hitam',
                              controller: colorController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: setPrimary,
                        activeColor: AppColors.primaryRed,
                        title: const Text(
                          'Jadikan kendaraan utama',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onChanged: (val) {
                          setSheetState(() => setPrimary = val ?? false);
                        },
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameController.text.trim().isEmpty ||
                                plateController.text.trim().isEmpty) {
                              return;
                            }
                            _store.addVehicle(
                              name: nameController.text,
                              plateNumber: plateController.text,
                              vehicleType: selectedType,
                              colorLabel: colorController.text,
                              setAsPrimary: setPrimary,
                            );
                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSheetField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5.0),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 11.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.primaryRed,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Kendaraan Terdaftar'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final vehicles = _store.vehicles;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'DAFTAR KENDARAAN',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: AppColors.subtleCardBorder,
                            ),
                          ),
                          child: Text(
                            '${vehicles.length} Unit',
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < vehicles.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1.0,
                                color: Color(0xFFF3F4F6),
                                indent: 18.0,
                                endIndent: 18.0,
                              ),
                            _buildVehicleRow(
                              vehicles[i],
                              canDelete: vehicles.length > 1,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: ElevatedButton.icon(
                        onPressed: _openAddVehicleSheet,
                        icon: const Icon(Icons.add, size: 19.0),
                        label: const Text(
                          'Tambah Kendaraan',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleRow(
    RegisteredVehicle vehicle, {
    required bool canDelete,
  }) {
    final isMotor = vehicle.vehicleType == VehicleType.motor;

    return InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: vehicle.isPrimary
          ? null
          : () => _store.setPrimaryVehicle(vehicle.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(
              isMotor
                  ? Icons.two_wheeler_outlined
                  : Icons.directions_car_outlined,
              color: const Color(0xFF525866),
              size: 21.0,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          vehicle.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (vehicle.isPrimary) ...[
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            'Utama',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${vehicle.plateNumber} • ${isMotor ? 'Motor' : 'Mobil'} • ${vehicle.colorLabel}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!vehicle.isPrimary)
              TextButton(
                onPressed: () => _store.setPrimaryVehicle(vehicle.id),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  minimumSize: const Size(0, 32.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Pilih',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: AppColors.avatarDeepRed,
                  ),
                ),
              ),
            if (canDelete)
              IconButton(
                tooltip: 'Hapus Kendaraan',
                visualDensity: VisualDensity.compact,
                onPressed: () => _store.removeVehicle(vehicle.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 19.0,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
