import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const EResidencyApp());
}

class EResidencyApp extends StatelessWidget {
  const EResidencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eResidency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0088FF),
          surface: Color(0xFF1A1A1A),
        ),
      ),
      home: const EResidencyScreen(),
    );
  }
}

class CardData {
  String fullName;
  String number;
  String iin;
  String birthDate;
  String expiryDate;
  Uint8List? photo;

  CardData({
    this.fullName = 'ROMAN SIUNIAKOV',
    this.number = '467040127854',
    this.iin = '000926051288',
    this.birthDate = '26.09.2000',
    this.expiryDate = '06.05.2027',
    this.photo,
  });
}

class EResidencyScreen extends StatefulWidget {
  const EResidencyScreen({super.key});

  @override
  State<EResidencyScreen> createState() => _EResidencyScreenState();
}

class _EResidencyScreenState extends State<EResidencyScreen> {
  int _selectedIndex = 0;
  int _logoTapCount = 0;
  final CardData _data = CardData();

  void _onLogoTap() {
    _logoTapCount++;
    if (_logoTapCount >= 5) {
      _logoTapCount = 0;
      _openEditSheet();
    }
  }

  void _openEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditCardSheet(
        data: _data,
        onSave: (updated) => setState(() {
          _data.fullName = updated.fullName;
          _data.number = updated.number;
          _data.iin = updated.iin;
          _data.birthDate = updated.birthDate;
          _data.expiryDate = updated.expiryDate;
          if (updated.photo != null) _data.photo = updated.photo;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildLogo(),
            const SizedBox(height: 40),
            _buildIdCard(),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildLogo() {
    return GestureDetector(
      onTap: _onLogoTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ELogoMark(),
          const SizedBox(width: 6),
          _ResidencyBadge(),
        ],
      ),
    );
  }

  Widget _buildIdCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B3F75),
              Color(0xFF0D2550),
              Color(0xFF081830),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0055BB).withOpacity(0.4),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardHeader(),
              const SizedBox(height: 48),
              _buildCardBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Цифровая ID карта',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _data.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _KazakhstanFlag(),
      ],
    );
  }

  Widget _buildCardBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Номер:', _data.number),
              const SizedBox(height: 14),
              _buildField('ИИН:', _data.iin),
              const SizedBox(height: 14),
              _buildField('Дата рождения:', _data.birthDate),
              const SizedBox(height: 14),
              _buildField('Срок действия:', _data.expiryDate),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 88,
          height: 108,
          decoration: BoxDecoration(
            color: const Color(0xFFD8C4B0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.5),
            child: _data.photo != null
                ? Image.memory(_data.photo!, fit: BoxFit.cover)
                : Container(
                    color: const Color(0xFFDFCBB7),
                    child: const Icon(
                      Icons.person,
                      size: 56,
                      color: Color(0xFFAA8870),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.credit_card_rounded, 'eResidency'),
              _buildNavItem(1, Icons.sim_card_outlined, 'eSIM'),
              _buildNavItem(2, Icons.apps_rounded, 'Услуги'),
              _buildNavItem(3, Icons.account_circle_outlined, 'Профиль'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? const Color(0xFF0088FF)
        : Colors.white.withOpacity(0.45);

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Логотип «e» ────────────────────────────────────────────────────────────

class _ELogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2BA0FF), Color(0xFF0066DD)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0088FF).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Transform.translate(
          offset: const Offset(1, 0),
          child: const Text(
            'e',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResidencyBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'RESIDENCY',
        style: TextStyle(
          color: Color(0xFF111111),
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.5,
        ),
      ),
    );
  }
}

// ─── Флаг Казахстана ─────────────────────────────────────────────────────────

class _KazakhstanFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Flag_of_Kazakhstan.svg/320px-Flag_of_Kazakhstan.svg.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => const Center(
          child: Text('🇰🇿', style: TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}

// ─── Форма редактирования ─────────────────────────────────────────────────────

class EditCardSheet extends StatefulWidget {
  final CardData data;
  final void Function(CardData) onSave;

  const EditCardSheet({super.key, required this.data, required this.onSave});

  @override
  State<EditCardSheet> createState() => _EditCardSheetState();
}

class _EditCardSheetState extends State<EditCardSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _iinCtrl;
  late final TextEditingController _birthCtrl;
  late final TextEditingController _expiryCtrl;
  Uint8List? _pickedPhoto;
  bool _picking = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.data.fullName);
    _numberCtrl = TextEditingController(text: widget.data.number);
    _iinCtrl = TextEditingController(text: widget.data.iin);
    _birthCtrl = TextEditingController(text: widget.data.birthDate);
    _expiryCtrl = TextEditingController(text: widget.data.expiryDate);
    _pickedPhoto = widget.data.photo;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _iinCtrl.dispose();
    _birthCtrl.dispose();
    _expiryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 90,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() => _pickedPhoto = bytes);
      }
    } finally {
      setState(() => _picking = false);
    }
  }

  void _save() {
    widget.onSave(CardData(
      fullName: _nameCtrl.text.trim().toUpperCase(),
      number: _numberCtrl.text.trim(),
      iin: _iinCtrl.text.trim(),
      birthDate: _birthCtrl.text.trim(),
      expiryDate: _expiryCtrl.text.trim(),
      photo: _pickedPhoto,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Редактировать карту',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            _buildPhotoRow(),
            const SizedBox(height: 24),
            _buildField('Фамилия и имя', _nameCtrl,
                hint: 'IVAN IVANOV', caps: true),
            const SizedBox(height: 16),
            _buildField('Номер документа', _numberCtrl,
                hint: '467040127854', keyboard: TextInputType.number),
            const SizedBox(height: 16),
            _buildField('ИИН', _iinCtrl,
                hint: '000926051288', keyboard: TextInputType.number),
            const SizedBox(height: 16),
            _buildField('Дата рождения', _birthCtrl, hint: '26.09.2000'),
            const SizedBox(height: 16),
            _buildField('Срок действия', _expiryCtrl, hint: '06.05.2027'),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickPhoto,
          child: Container(
            width: 80,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF0088FF).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.5),
              child: _pickedPhoto != null
                  ? Image.memory(_pickedPhoto!, fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined,
                            color: Colors.white.withOpacity(0.5), size: 28),
                        const SizedBox(height: 6),
                        Text(
                          'Фото',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Фото для карты',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Нажмите на квадрат, чтобы выбрать фото из галереи',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickPhoto,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088FF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF0088FF).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    _picking ? 'Загрузка...' : 'Выбрать фото',
                    style: const TextStyle(
                      color: Color(0xFF0088FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    String hint = '',
    bool caps = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          textCapitalization:
              caps ? TextCapitalization.characters : TextCapitalization.none,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF0088FF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
