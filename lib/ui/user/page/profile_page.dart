import 'dart:io';
import 'package:financas/domain/entities/user/user_entity.dart';
import 'package:financas/ui/authentication/cubit/auth_cubit.dart';
import 'package:financas/ui/authentication/pages/login_page.dart';
import 'package:financas/ui/charts/view/charts_page.dart';
import 'package:financas/ui/user/cubit/user_cubit.dart';
import 'package:financas/ui/user/cubit/user_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _image;

  @override
  void initState() {
    super.initState();
    loadImage();
    context.read<UserCubit>().getUser();
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
      saveImage(_image!.path);
    }
  }

  Future<void> loadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      setState(() {
        _image = XFile(imagePath);
      });
    }
  }

  Future<void> saveImage(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                _buildUserProfileSection(state.user),
                const SizedBox(height: 20),
                _buildActionsSection(context, state.user),
              ],
            );
          }
          return const Center(child: Text('Nenhum usuário encontrado.'));
        },
      ),
    );
  }

  Widget _buildUserProfileSection(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: uploadImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  _image != null ? FileImage(File(_image!.path)) : null,
              child: _image == null
                  ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.nome,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "user.email",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, User user) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar Perfil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEditProfileDialog(context, user),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Ver Gráficos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChartsPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Sair da Conta',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final navigator = Navigator.of(context);
              await context
                  .read<AuthCubit>()
                  .firebaseRepository
                  .exitAccoutnFirebase();
              if (!mounted) return;
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfileDialog(
      BuildContext context, User currentUser) async {
    final TextEditingController nameController =
        TextEditingController(text: currentUser.nome);
    final TextEditingController emailController =
        TextEditingController(text: currentUser.email);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Perfil'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newUser = User(
                      email: emailController.text,
                      nome: nameController.text,
                      senha: '');
                  await context.read<AuthCubit>().updateUser(newUser);
                  context.read<UserCubit>().getUser();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
