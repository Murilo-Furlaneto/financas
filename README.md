Este aplicativo Flutter permite que os usuários gerenciem suas finanças pessoais de forma eficiente, oferecendo funcionalidades completas para controle de gastos e visualização de dados. O aplicativo utiliza o Cubit para gerenciamento de estado, garantindo um desenvolvimento ágil e uma performance otimizada.
Funcionalidades Principais

    Autenticação:

        Login, cadastro e recuperação de senha.

        Armazenamento seguro de usuários e acessos no Firebase.

        Comunicação com um servidor externo para autenticação.

        Identificação e redirecionamento do usuário para as funcionalidades do app.

        Restauração automática do usuário que já fez login anteriormente.

    Gerenciamento de Perfil:

        Upload e restauração de imagem de perfil (câmera ou galeria).

    Contas:

        Cadastro, armazenamento e visualização de contas.

    Tela Inicial (Home Screen):

        Funcionalidade principal para salvar as despesas mensais.

        Layout com gráficos interativos mostrando o pico de movimentação financeira por dia da semana.

    Gerenciamento de Estado:

        Utilização do Cubit para todos os módulos, garantindo reatividade e simplicidade no gerenciamento de estados

    Outros:

        Launcher Icons personalizados.

        Suporte a diferentes ambientes (dev, teste, produção) via Flavors.

        Handle de imagens para upload e restauração do Storage.

Arquitetura

O aplicativo foi desenvolvido utilizando a arquitetura MVVM, visando a separação de responsabilidades e a facilidade de manutenção.
Tecnologias Utilizadas

    Flutter

    Dart

    Cubit (Gerenciamento de Estado)

    Firebase (Autenticação e Armazenamento)

Como Executar o Projeto

    Clone o repositório.

    Execute flutter pub get para instalar as dependências.

    Execute flutter run para rodar o aplicativo.

Imagens 

![Captura de tela 2025-10-04 150736](https://github.com/user-attachments/assets/8f3f355f-ba38-4de8-945a-d2a5cc79fbe2)
![Captura de tela 2025-10-04 151346](https://github.com/user-attachments/assets/6cf65ada-15d0-44b2-b770-8884d45e297f)
![Captura de tela 2025-10-04 151409](https://github.com/user-attachments/assets/c5d1515b-e8ea-43a9-a1fe-b17bba279b37)
![Captura de tela 2025-10-04 151420](https://github.com/user-attachments/assets/906fd403-3267-4b7b-bf26-b613f1edcc62)
![Captura de tela 2025-10-04 151528](https://github.com/user-attachments/assets/abbc5985-2cc2-40cc-991b-3ceecbff94f6)
![Captura de tela 2025-10-04 151547](https://github.com/user-attachments/assets/1d1d71b4-69ab-4831-9dea-1253a4a9809f)

