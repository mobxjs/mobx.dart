import * as React from 'react';
import { Helmet } from 'react-helmet-async';
import { useConfig } from 'docz';

const Wrapper = ({ children }) => {
  const { favicon } = useConfig();

  return (
    <React.Fragment>
      <Helmet>
        <meta charSet="utf-8" />
        <link rel="icon" type="image/png" href={favicon} />
      </Helmet>
      {children}
    </React.Fragment>
  );
};
export default Wrapper;
