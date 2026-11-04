import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfileStore? store;

  const EditProfileScreen({
    super.key,
    this.store,
  });

  static MaterialPageRoute<void> route({UserProfileStore? store}) {
    return MaterialPageRoute<void>(
      builder: (_) => EditProfileScreen(store: store),
    );
  }

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  late final TextEditingController _facultyController;
  late final TextEditingController _prodiController;
  late final TextEditingController _phoneController;

  UserProfileStore get _store =>
      widget.store ?? MockUserProfileData.sharedStore;

  @override
  void initState() {
    super.initState();
    final profile = _store.profile;
    _nameController = TextEditingController(text: profile.fullName);
    _nimController = TextEditingController(text: profile.nim);
    _facultyController = TextEditingController(text: profile.faculty);
    _prodiController = TextEditingController(text: profile.studyProgram);
    _phoneController = TextEditingController(text: profile.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _facultyController.dispose();
    _prodiController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final fullName = _nameController.text.trim();
    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: AppColors.avatarDeepRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: const Text('Nama lengkap wajib diisi.'),
          ),
        );
      return;
    }

    _store.updateProfile(
      _store.profile.copyWith(
        fullName: fullName,
        nim: _nimController.text.trim(),
        faculty: _facultyController.text.trim(),
        studyProgram: _prodiController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Text(
            'Profil berhasil disimpan.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profile = _store.profile;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Edit Profil'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 32.0),
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Container(
                    width: 68.0,
                    height: 68.0,
                    decoration: const BoxDecoration(
                      color: AppColors.avatarDeepRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  profile.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24.0),

                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(color: AppColors.subtleCardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'Nama Lengkap',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 14.0),
                      _buildInputField(
                        label: 'NIM',
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14.0),
                      _buildInputField(
                        label: 'Fakultas',
                        controller: _facultyController,
                      ),
                      const SizedBox(height: 14.0),
                      _buildInputField(
                        label: 'Program Studi',
                        controller: _prodiController,
                      ),
                      const SizedBox(height: 14.0),
                      _buildInputField(
                        label: 'Nomor Telepon',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
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
        const SizedBox(height: 6.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 13.8,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
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
}
