use std::marker::PhantomData;
use std::fmt;

pub struct Key<T> {
    #[doc(hidden)]
    pub __name: &'static str,
    #[doc(hidden)]
    pub __phantom: PhantomData<T>,
}

impl<T> Copy for Key<T> {}

impl<T> Clone for Key<T> {
    fn clone(&self) -> Self {
        Key {
            __name: self.__name,
            __phantom: self.__phantom,
        }
    }
}

fn main() {}
