import getURL from "discourse/lib/get-url";

const EXTERNAL_URL = /^https?:\/\//;

export function isVisibleTo(link, currentUser) {
  switch (link.audience) {
    case "staff":
      return !!currentUser?.staff;
    case "logged_in":
      return !!currentUser;
    case "anonymous":
      return !currentUser;
    default:
      return true;
  }
}

export function decorateLink(link) {
  const external = EXTERNAL_URL.test(link.url);
  return {
    ...link,
    external,
    href: external ? link.url : getURL(link.url),
  };
}
