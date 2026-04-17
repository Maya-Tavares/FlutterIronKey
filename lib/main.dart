import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

// run terminal: flutter pub get
void main() {
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

  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = true;
  bool includeSymbols = false;

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
    final PasswordGenerator generator;
      
    switch(passwordSelectedType){

      case PasswordType.pin:
      generator = PinPasswordGenerator();
      break;

      case PasswordType.standard:
        generator = StandardPasswordGenerator(
              includeUppercase: includeUppercase,
              includeLowercase: includeLowercase,
              includeNumbers: includeNumbers,
              includeSymbols: includeSymbols,
        );
        break;
    }
    
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        
        child: Column(
          
          children: [
            //////////////////////// FORMULÁRIO
            ///
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    //////////// imagem
                    ///
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset("assets/images/ironman.jpg"),
                      ),
                    ),
                
                    //////////
                    ////////////// Titulo
                    SizedBox(height: 16),
                    Text(
                      "Sua senha segura",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                                onPressed: () {
                                  copyPassword(_passwordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),
                    //////////
                    /////////////Tipo de senha
                    ///
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tipo de senha'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<PasswordType>(
                            value: PasswordType.pin,
                            groupValue: passwordSelectedType,
                            title: const Text('PIN'),
                            onChanged: (value) {
                              setState(() {
                                passwordSelectedType = value!;
                              });
                            },
                          ),
                        ),
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
                    Divider(color: colorScheme.outline),
                
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
                          },
                        ),
                      ],
                    ),

                    Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ['Baixa', 'Média', 'Alta']
                    .map(
                    (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                    ),
                    )
                    .toList(),
                    onChanged: (value) {
                    setState(() {
                    selectedValue = value!;
                    });
                    },
                    ),
                    ),
                
                    Divider(color: colorScheme.outline),
                    SizedBox(height: 20),
                    // ... [] se o anterior for true, tudo o que está dentro acontece.
                    if (isEditable) ... [
                      Align(alignment: Alignment.centerLeft,
                      child: Text("Tamanho da senha: $maxCharacters."),
                      ),
                      ///////////////////////////////////
                      //// slider: barrinha que puxa
                      Slider(
                        value: maxCharacters.toDouble(),
                        min: 4,
                        max: 12, 
                      onChanged: (value){
                        // Setsate() --> a tela muda de estado junto com a mudança do valor
                          setState(() {
                            maxCharacters = value.toInt();
                          });
                      }),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text("Maiúscula"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: includeUppercase,
                              onChanged: (value){
                                setState(() {
                                  includeUppercase = value ?? false;
                                });
                              }),
                          ),

                          Expanded(
                            child: CheckboxListTile(
                              title: Text("Minúscula"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: includeLowercase,
                              onChanged: (value){
                                setState(() {
                                  includeLowercase = value ?? false;
                                });
                              }),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text("Número"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: includeNumbers,
                              onChanged: (value){
                                setState(() {
                                  includeNumbers = value ?? false;
                                });
                              }),
                          ),

                          Expanded(
                            child: CheckboxListTile(
                              title: Text("Símbolos"),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: includeSymbols,
                              onChanged: (value){
                                setState(() {
                                  includeSymbols = value ?? false;
                                });
                              }),
                          )
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),

            //////////
            /////////////Button GERAR SENHA
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  generatePassword();
                },
                child: Text("Gerar Senha"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
