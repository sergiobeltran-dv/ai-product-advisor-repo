# Frontend Application

This directory will contain the frontend application code for the AI Product Advisor.

## Planned Structure

```
frontend/
├── public/                    # Static assets
│   ├── index.html
│   ├── favicon.ico
│   └── assets/
├── src/
│   ├── components/           # React components
│   │   ├── Chat/            # Chat interface
│   │   ├── Search/          # Product search
│   │   └── Common/          # Shared components
│   ├── pages/               # Page components
│   │   ├── Home/
│   │   ├── ProductCatalog/
│   │   └── ChatInterface/
│   ├── services/            # API clients
│   │   ├── chatService.ts
│   │   └── searchService.ts
│   ├── hooks/               # Custom React hooks
│   ├── utils/               # Utility functions
│   ├── types/               # TypeScript types
│   ├── styles/              # Global styles
│   ├── App.tsx
│   └── index.tsx
├── tests/                    # Unit and integration tests
│   ├── unit/
│   └── integration/
├── package.json
├── tsconfig.json
└── vite.config.ts           # or webpack.config.js
```

## Technology Stack

- **Framework**: React 18+ with TypeScript
- **Build Tool**: Vite (or Create React App)
- **Styling**:
  - Tailwind CSS or Material-UI
  - CSS Modules
- **State Management**:
  - React Context API
  - React Query (for server state)
- **Routing**: React Router v6
- **HTTP Client**: Axios or Fetch API
- **Testing**:
  - Jest
  - React Testing Library

## Development Setup

_To be documented when frontend development begins_

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Run tests
npm test
```

## Environment Variables

Create a `.env.local` file (not committed to git):

```
VITE_API_BASE_URL=https://<function-app-name>.azurewebsites.net
VITE_ENVIRONMENT=development
```

For production, these are configured in Azure App Service application settings.

## Deployment

### Azure App Service (Static Web App)

Deployment is handled via Azure DevOps pipelines in `.azuredevops/pipelines/`

```bash
# Manual deployment (if needed)
npm run build
az webapp up --name <app-service-name> --resource-group <resource-group>
```

### Static Web App Alternative

```bash
# Deploy to Azure Static Web Apps
npm run build
swa deploy ./dist --deployment-token $DEPLOYMENT_TOKEN
```

## Key Features

- **Product Search**: Search ElectroRent product catalog with AI-powered recommendations
- **Chat Interface**: Real-time chat with AI assistant for product inquiries
- **Product Details**: View detailed product specifications and pricing
- **Responsive Design**: Mobile-first responsive design
- **Accessibility**: WCAG 2.1 AA compliant

## API Integration

The frontend communicates with the backend Azure Functions API:

- `POST /api/chat` - Send chat messages and receive AI responses
- `GET /api/search` - Search products with filters
- `GET /api/products/:id` - Get product details
- `GET /api/health` - Health check endpoint

## Testing

```bash
# Run unit tests
npm test

# Run tests with coverage
npm run test:coverage

# Run e2e tests
npm run test:e2e
```

## Code Quality

```bash
# Lint code
npm run lint

# Format code
npm run format

# Type check
npm run type-check
```

## Performance Optimization

- Code splitting with React.lazy()
- Image optimization
- Bundle size optimization
- Service worker for offline support (PWA)
- CDN for static assets

## Security

- Content Security Policy (CSP) headers
- HTTPS only
- Input sanitization
- XSS protection
- CORS configuration

## Contributing

_Team guidelines to be added_

### Branch Strategy

- `main` - Production
- `develop` - Development integration
- `feature/*` - Feature branches
- `hotfix/*` - Production hotfixes

### Commit Convention

Follow Conventional Commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test changes
- `chore:` - Build/tooling changes

## Browser Support

- Chrome (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)
- Edge (latest 2 versions)
- No IE11 support

## Accessibility

- Semantic HTML
- ARIA labels where needed
- Keyboard navigation
- Screen reader support
- Color contrast compliance

## Monitoring

- Application Insights integration
- Error tracking
- Performance monitoring
- User analytics

## Documentation

- Component Storybook (to be added)
- API documentation
- User guide
- Developer onboarding guide
