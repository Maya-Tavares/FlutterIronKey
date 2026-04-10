import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';
// run terminal: flutter pub get 
void main (){
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // .system é o correto. Light para teste.
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

  enum PasswordType { pin, standard }

class _IronKeyScreenState extends State<IronKeyScreen> {

  final TextEditingController _passwordController = TextEditingController();

  PasswordType passwordSelectedType = PasswordType.pin;
  int maxCharacters = 12;
  bool isEditable = false;

  @override
  void initState() {
    // ouvinte
    super.initState();
      _passwordController.addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // evita que o listener fique conectado
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
  Clipboard.setData(ClipboardData(text: password));
  ScaffoldMessenger.of(
  context,
  ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

    void generatePassword() {
      final PasswordGenerator generator = passwordSelectedType ==
      PasswordType.pin
      ? PinPasswordGenerator()
      : StandardPasswordGenerator();
      final result = generator.generate(maxCharacters);
      setState(() {
      _passwordController.text = result;
 });

    // const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    // const lower = "abcdefghijklmnopqrstuvwxyz";
    // const numbers = "0123456789";
    // const symbols = "!@#\$%&*";
    // final chars = upper + lower + numbers + symbols;
    // final random = Random();

    // setState(() {
    // _passwordController.text = List.generate(
    //   12,
    // (_) => chars[random.nextInt(chars.length)],
    // ).join();
    // });

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Column(
          //////////// imagem
          children: [
            Expanded(child: Column( children: [
              ClipOval(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/ironman.jpg")),
              ),

              //////////
              ////////////// Titulo
              
              SizedBox(height: 16),
              Text(
                "Sua senha segura",
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 24
                  ),
              ),

              //////////
              /////////////Senha
              
                SizedBox(height: 16),
                TextField(
                  enabled: isEditable,
                  maxLength: maxCharacters,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: _passwordController.text.isNotEmpty 
                    ? IconButton(
                      onPressed: (){
                      copyPassword(_passwordController.text);
                    }, 
                    icon: Icon(Icons.copy)) : null,
                  ),
                ),
                Text(_passwordController.text)
            ])
            ),

            //////////
              /////////////Tipo de senha
              ///
            Align(alignment: Alignment.centerLeft, child: Text('Tipo de senha'),),
                Row(children: [Expanded(
                  child: RadioListTile<PasswordType>(
                  value: PasswordType.pin,
                  groupValue: passwordSelectedType,
                  title: const Text('PIN'),
                  onChanged: (value) {
                    setState(() {
                passwordSelectedType = value!;
                });
              },
            ),),
                Expanded(
                  child: RadioListTile<PasswordType>(
                  value: PasswordType.standard,
                  groupValue: passwordSelectedType,
                  title: const Text('Senha padrão'),
                  onChanged: (value) {
                    setState(() {
                  passwordSelectedType = value!;
                });
              },
            ),
          ),
                ],
                ),

                //////////
              /////////////PERMISSAO EDITAR SENHA
                Divider(color: ColorScheme.outline),

                Row(
                  children: [
                    Icon(isEditable ? Icons.lock_open : Icons.lock),
                    Text("Permite editar a senha? "),
                    Switch(
                      value: isEditable,
                      onChanged: (value) {
                        setState(() {
                          isEditable = value;
                        });
                      }
                    )
                  ],
                ),

                Divider(color: ColorScheme.outline),
                SizedBox(height: 20),

                if(isEditable) Text("Estou no modo de edição"),

              //////////
              /////////////Button GERAR SENHA
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () {}, child: Text("Gerar Senha")))
          ],
        )
      ),
    );
  }


}
