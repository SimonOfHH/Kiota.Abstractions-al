# Kiota.Abstractions for AL Language

This repository provides a foundational app for supporting API clients generated with [Kiota](https://github.com/microsoft/kiota) in the AL language for Microsoft Dynamics 365 Business Central. 

## Overview

Kiota is an open-source project by Microsoft that generates API clients for various programming languages. This repository is a companion app for the AL language support added in the [SimonOfHH/kiota](https://github.com/SimonOfHH/kiota) fork of the official [microsoft/kiota](https://github.com/microsoft/kiota) repository.

In Business Central, API clients generated with Kiota are packaged as extensions (Apps). This app (`Kiota.Abstractions`) serves as a dependency for all such generated API client extensions. It provides base classes, interfaces, and utilities required for the generated clients to function.

## Features

- **Base Classes and Interfaces**: Includes foundational components like `Kiota IApiClient` and `Kiota IModelClass` interfaces.
- **Utilities**: Provides helper codeunits for JSON handling (`JSON Helper SOHH`) and stream operations (`StreamHelper SOHH`).
- **Client Configuration**: Includes a `Kiota ClientConfig` codeunit for managing API client configurations.
- **Request Handling**: Contains a `Kiota RequestHandler` codeunit for managing HTTP requests and responses.

## Installation

To use this app, it must be installed in your Business Central environment. All API client extensions generated with Kiota in AL will declare this app as a dependency.

## Future Plans

This repository is a companion app for the AL language support in the [SimonOfHH/kiota](https://github.com/SimonOfHH/kiota) fork. If and when the AL language support is merged into the original Kiota project, this app may be moved to a different location or integrated into the main repository.

## Contributing

Contributions are welcome! If you have suggestions, bug reports, or improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the same terms as the original Kiota repository. See the [LICENSE](https://github.com/microsoft/kiota/blob/main/LICENSE) file in the original repository for details.

## Acknowledgments

Special thanks to the [Kiota](https://github.com/microsoft/kiota) team for their work on the original project.

---
**Note**: This is a first draft of AL language support for Kiota. Expect changes and improvements as the project evolves.